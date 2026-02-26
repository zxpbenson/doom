#!/usr/bin/env bash

show_help() {
  cat <<EOF
Usage:
  $0 -i <input_dir> -o <output_dir> [options]

Options:
  -i                         输入目录（mp3）
  -o                         输出目录（必须为空或不存在）
  --dry-run                  只打印将要处理的文件
  --continue-on-error        出错继续（默认）
  --no-continue-on-error     出错即停止
  -h, --help                 显示帮助

Example:
  $0 -i ./broken_mp3 -o ./fixed_mp3
  $0 -i ./broken_mp3 -o ./fixed_mp3 --dry-run
EOF
}

INPUT_DIR=""
OUTPUT_DIR=""
DRY_RUN=false
CONTINUE_ON_ERROR=true

while [[ $# -gt 0 ]]; do
  case "$1" in
    -i) INPUT_DIR="$2"; shift 2 ;;
    -o) OUTPUT_DIR="$2"; shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    --continue-on-error) CONTINUE_ON_ERROR=true; shift ;;
    --no-continue-on-error) CONTINUE_ON_ERROR=false; shift ;;
    -h|--help) show_help; exit 0 ;;
    *) echo "Unknown option: $1"; show_help; exit 1 ;;
  esac
done

if [[ -z "$INPUT_DIR" || -z "$OUTPUT_DIR" ]]; then
  echo "Error: input and output directories are required"
  exit 1
fi

if [[ ! -d "$INPUT_DIR" ]]; then
  echo "Error: input directory does not exist"
  exit 1
fi

INPUT_REAL="$(realpath "$INPUT_DIR")"
OUTPUT_REAL="$(realpath "$OUTPUT_DIR" 2>/dev/null || true)"

if [[ "$INPUT_REAL" == "$OUTPUT_REAL" ]]; then
  echo "Error: input and output directories must be different"
  exit 1
fi

if [[ -d "$OUTPUT_DIR" ]]; then
  if [[ -n "$(ls -A "$OUTPUT_DIR")" ]]; then
    echo "Error: output directory is not empty"
    exit 1
  fi
else
  mkdir -p "$OUTPUT_DIR"
fi

REPORT="$OUTPUT_DIR/fix_report.txt"

{
  echo "Fix MP3 Report"
  echo "Start Time : $(date '+%Y-%m-%d %H:%M:%S')"
  echo "Input Dir  : $INPUT_REAL"
  echo "Output Dir : $(realpath "$OUTPUT_DIR")"
  echo "Dry Run    : $DRY_RUN"
  echo "Continue   : $CONTINUE_ON_ERROR"
  echo "----------------------------------------"
} > "$REPORT"

shopt -s nullglob

for mp3 in "$INPUT_DIR"/*.mp3; do
  filename="$(basename "$mp3")"
  name="${filename%.mp3}"
  fixed_mp3="$OUTPUT_DIR/${name}.fixed.mp3"
  tmp_m4a="$OUTPUT_DIR/${name}.tmp.m4a"

  if $DRY_RUN; then
    echo "[DRY-RUN] $mp3 -> $fixed_mp3"
    echo "DRY-RUN : $filename" >> "$REPORT"
    continue
  fi

  echo "Processing: $filename"

  if ! ffmpeg -y -loglevel error -i "$mp3" -c:a aac -b:a 256k "$tmp_m4a"; then
    echo "FAILED (mp3->m4a): $filename" >> "$REPORT"
    rm -f "$tmp_m4a"
    $CONTINUE_ON_ERROR || exit 1
    continue
  fi

  if ! ffmpeg -y -loglevel error -i "$tmp_m4a" -vn -c:a libmp3lame -q:a 0 -b:a 192k "$fixed_mp3"; then
    echo "FAILED (m4a->mp3): $filename" >> "$REPORT"
    rm -f "$tmp_m4a"
    $CONTINUE_ON_ERROR || exit 1
    continue
  fi

  rm -f "$tmp_m4a"
  echo "OK     : $filename -> $(basename "$fixed_mp3")" >> "$REPORT"
done

echo "----------------------------------------" >> "$REPORT"
echo "End Time : $(date '+%Y-%m-%d %H:%M:%S')" >> "$REPORT"

echo "All done."
echo "Report: $REPORT"

