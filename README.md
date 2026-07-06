# mvsng

A simple Bash script to automate installing **Clone Hero** songs from `.zip` archives.

It unzips a downloaded song (or a whole folder of zipped songs), moves the contents into your `Songs/` directory under a folder named after the song, and converts any `video.mp4` background/highway video to `.webm` (Clone Hero's preferred format) along the way.

## Features

- Extracts a single song `.zip` or an entire directory of them.
- Automatically names the destination folder after the song.
- Converts `video.mp4` to `video.webm` using `ffmpeg` (`libvpx` + `libopus`), then removes the original `.mp4`.
- Cleans up the temporary extraction folder after moving files into place.

## Requirements

- `bash`
- `unzip`
- `ffmpeg` (with `libvpx` and `libopus` support)
- `file` (usually preinstalled on Linux)

## Usage

```bash
mvsng [zip]           # Move and extract a single .zip file
mvsng -d [directory]  # Move and extract every .zip file inside a directory
```

### Examples

```bash
mvsng song.zip          # extracts song.zip into $SONGS_FOLDER/<song name>/
mvsng -d ./songs/       # processes every .zip file inside ./songs/
```

### Invalid usage

```bash
mvsng song.txt     # not a zip file - rejected
mvsng -d song.zip  # -d expects a directory, not a file - rejected
mvsng -d           # missing directory argument - rejected
mvsng              # no arguments - rejected
```

## How it works

1. Verifies the argument is either a valid `.zip` file or, with `-d`, a valid directory containing `.zip` files.
2. Derives the song name from the file name (stripping anything in parentheses, e.g. `Song Name (Charter).zip` → `Song Name`).
3. Creates `SONGS_FOLDER/<Song Name>/` and unzips the archive into it.
4. Looks for an `MP4` file inside the extracted contents and, if found, converts it to `.webm` with `ffmpeg`, removing the original.
5. Moves everything out of the nested extracted subfolder into the final destination folder and removes the now-empty subfolder.

## Known limitations

- Assumes the zip contains a single top-level folder with the song's contents (typical of most Clone Hero song downloads).
- Only detects and converts a video file if `file` reports it as `MP4`; other video formats are left untouched.
- Song names containing certain special characters may need extra quoting/escaping.
- Not extensively tested with nested or unusually structured archives - review the output if a song doesn't look right after conversion.
