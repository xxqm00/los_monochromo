#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────
#  「✦ POMODORO TIMER ✦ 」
# ─────────────────────────────────────────────────────────────────────
# WAYBAR MODULE WITH AUTOMATIC POMODORO SEQUENCE
# ─────────────────────────────────────────────────────────────────────

STATE_FILE=/tmp/break_state
PRESET_FILE=/tmp/break_preset
PAUSED_FILE=/tmp/break_paused
WORK_COUNT_FILE=/tmp/break_work_count

MIN_PRESET=5
MAX_PRESET=120
STEP_PRESET=5
DEFAULT_PRESET=25

# ─── preset handling ────────────────────────────────────────────────
get_preset_minutes() {
  if [ -f "$PRESET_FILE" ]; then
    preset=$(cat "$PRESET_FILE" 2>/dev/null)
    case "$preset" in
      ''|*[!0-9]*)
        ;;
      *)
        if [ "$preset" -ge "$MIN_PRESET" ] && [ "$preset" -le "$MAX_PRESET" ]; then
          printf '%s\n' "$preset"
          return
        fi
        ;;
    esac
  fi
  printf '%s\n' "$DEFAULT_PRESET"
}

set_preset_minutes() {
  printf '%s\n' "$1" >"$PRESET_FILE"
}

adjust_preset() {
  current=$(get_preset_minutes)
  direction=$1

  if [ -f "$STATE_FILE" ]; then
    exit 0
  fi

  if [ "$direction" = "next" ]; then
    new_preset=$((current + STEP_PRESET))
    if [ "$new_preset" -gt "$MAX_PRESET" ]; then
      new_preset=$MAX_PRESET
    fi
  else
    new_preset=$((current - STEP_PRESET))
    if [ "$new_preset" -lt "$MIN_PRESET" ]; then
      new_preset=$MIN_PRESET
    fi
  fi

  set_preset_minutes "$new_preset"
}

# ─── work count (consecutive 25‑minute sessions) ──────────────────
get_work_count() {
  if [ -f "$WORK_COUNT_FILE" ]; then
    count=$(cat "$WORK_COUNT_FILE" 2>/dev/null)
    case "$count" in
      ''|*[!0-9]*) echo 0 ;;
      *) echo "$count" ;;
    esac
  else
    echo 0
  fi
}

set_work_count() {
  echo "$1" > "$WORK_COUNT_FILE"
}

reset_work_count() {
  set_work_count 0
}

increment_work_count() {
  current=$(get_work_count)
  new=$((current + 1))
  set_work_count "$new"
}

# ─── timer control ──────────────────────────────────────────────────
start_timer() {
  duration_minutes=$(get_preset_minutes)
  duration_seconds=$((duration_minutes * 60))
  end_time=$(($(date +%s) + duration_seconds))
  echo "$end_time" >"$STATE_FILE"
  rm -f "$PAUSED_FILE"
  notify-send "Pomodoro Timer" "Started ${duration_minutes} minute timer"
}

pause_timer() {
  if [ ! -f "$STATE_FILE" ] || [ -f "$PAUSED_FILE" ]; then
    return
  fi

  now=$(date +%s)
  end_time=$(cat "$STATE_FILE" 2>/dev/null)
  remaining=$((end_time - now))

  if [ "$remaining" -le 0 ]; then
    rm -f "$STATE_FILE" "$PAUSED_FILE"
    return
  fi

  echo "$remaining" >"$STATE_FILE"
  touch "$PAUSED_FILE"

  min=$((remaining / 60))
  sec=$((remaining % 60))
  notify-send "Pomodoro Timer" "⏸ Paused at $(printf '%02d:%02d' "$min" "$sec")"
}

resume_timer() {
  if [ ! -f "$STATE_FILE" ] || [ ! -f "$PAUSED_FILE" ]; then
    return
  fi

  remaining=$(cat "$STATE_FILE" 2>/dev/null)
  case "$remaining" in
    ''|*[!0-9]*)
      rm -f "$STATE_FILE" "$PAUSED_FILE"
      return
      ;;
  esac

  end_time=$(($(date +%s) + remaining))
  echo "$end_time" >"$STATE_FILE"
  rm -f "$PAUSED_FILE"

  min=$((remaining / 60))
  sec=$((remaining % 60))
  notify-send "Pomodoro Timer" "▶️ Resumed at $(printf '%02d:%02d' "$min" "$sec")"
}

stop_timer() {
  rm -f "$STATE_FILE" "$PAUSED_FILE"
  notify-send "Pomodoro Timer" "⏹ Timer stopped"
}

# ─── print JSON for waybar ──────────────────────────────────────────
print_json() {
  text=$1
  tooltip=$2
  printf '{"text":"%s","tooltip":"%s"}\n' "$text" "$tooltip"
}

# ─── command handling ───────────────────────────────────────────────
case "$1" in
start)
  start_timer
  exit 0
  ;;
stop)
  stop_timer
  exit 0
  ;;
toggle)
  if [ -f "$STATE_FILE" ]; then
    if [ -f "$PAUSED_FILE" ]; then
      resume_timer
    else
      pause_timer
    fi
  else
    start_timer
  fi
  exit 0
  ;;
preset-next)
  adjust_preset next
  exit 0
  ;;
preset-prev)
  adjust_preset prev
  exit 0
  ;;
esac

# ─── main display logic ─────────────────────────────────────────────
duration_minutes=$(get_preset_minutes)

if [ ! -f "$STATE_FILE" ]; then
  print_json "Timer: ${duration_minutes}m" \
    "Scroll to adjust · click to start (${duration_minutes} min)"
  exit 0
fi

if [ -f "$PAUSED_FILE" ]; then
  remaining=$(cat "$STATE_FILE" 2>/dev/null)
  case "$remaining" in
    ''|*[!0-9]*)
      rm -f "$STATE_FILE" "$PAUSED_FILE"
      print_json "Timer: ${duration_minutes}m" \
        "Scroll to adjust · click to start (${duration_minutes} min)"
      exit 0
      ;;
  esac
  min=$((remaining / 60))
  sec=$((remaining % 60))
  print_json "Timer: ⏸ $(printf '%02d:%02d' "$min" "$sec")" \
    "Paused: click to resume · right‑click to stop"
  exit 0
fi

now=$(date +%s)
end_time=$(cat "$STATE_FILE" 2>/dev/null)
remaining=$((end_time - now))

if [ $remaining -le 0 ]; then
  # ─── timer finished: automatic next timer ──────────────────────
  rm -f "$STATE_FILE" "$PAUSED_FILE"

  # Determine next preset based on the preset that just finished
  finished_preset=$duration_minutes
  next_preset=25          # default fallback

  if [ "$finished_preset" -eq 25 ]; then
    increment_work_count
    work_count=$(get_work_count)
    if [ "$work_count" -ge 4 ]; then
      next_preset=30
      reset_work_count
    else
      next_preset=5
    fi
  elif [ "$finished_preset" -eq 5 ]; then
    next_preset=25
    # work count unchanged
  elif [ "$finished_preset" -eq 30 ]; then
    next_preset=25
    reset_work_count
  else
    # any other preset → go back to 25 and reset count
    next_preset=25
    reset_work_count
  fi

  set_preset_minutes "$next_preset"
  notify-send "Pomodoro Timer" "✅ ${finished_preset} min finished · Starting ${next_preset} min"
  start_timer

  # Immediately show the new running state
  duration_minutes=$next_preset
  end_time=$(cat "$STATE_FILE" 2>/dev/null)
  now=$(date +%s)
  remaining=$((end_time - now))
  min=$((remaining / 60))
  sec=$((remaining % 60))
  print_json "Timer: $(printf '%02d:%02d' "$min" "$sec")" \
    "Running: ${duration_minutes} min preset"
  exit 0
fi

min=$((remaining / 60))
sec=$((remaining % 60))
print_json "Timer: $(printf '%02d:%02d' "$min" "$sec")" \
  "Running: ${duration_minutes} min preset"