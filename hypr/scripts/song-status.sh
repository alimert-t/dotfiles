#!/bin/bash

# Initialize song_info variable
song_info="No media playing"

# Check for Spotify
player_name_spotify=$(playerctl -l | grep spotify)
player_status_spotify=$(playerctl --player=spotify status 2>/dev/null)

# If Spotify is running and playing music
if [[ "$player_status_spotify" == "Playing" ]]; then
  if [[ "$player_name_spotify" == *"spotify"* ]]; then
    song_info=$(playerctl --player=spotify metadata --format '{{title}}  󰓇   {{artist}}')
  fi
fi

# Check for YouTube in Firefox
player_name_firefox=$(playerctl -l | grep firefox)
player_status_firefox=$(playerctl --player=firefox status 2>/dev/null)

# If Firefox is running and playing a YouTube video
if [[ "$player_status_firefox" == "Playing" ]]; then
  # Check if it's a YouTube video based on the URL in the metadata
  url=$(playerctl --player=firefox metadata xesam:url 2>/dev/null)
  if [[ "$url" == *"youtube.com"* ]]; then
    video_title=$(playerctl --player=firefox metadata --format '{{title}}')
    song_info="$video_title  󰈹   YouTube"
  fi
fi

# Output the media information (Spotify song or YouTube video)
echo "$song_info"
