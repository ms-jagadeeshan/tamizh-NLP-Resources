#!/bin/bash
set -o pipefail

# set -x
# Constants
readonly SYNTHESIS_URL="http://speech.ssn.edu.in/SpeechSynthesis/synthesise.php"
readonly AUDIO_BASE_URL="http://speech.ssn.edu.in/SpeechSynthesis/wav"
readonly DEFAULT_VOICE="hts_tamil_female"

# Function to send a POST request and get the audio URL
get_audio_url() {
    local text="$1"
    local voice="${2:-$DEFAULT_VOICE}"

    local curl_output
    curl_output=$(curl -sD - "$SYNTHESIS_URL" -H "Content-Type: application/x-www-form-urlencoded" --data "options=$voice&word=$text")

    local audio_filename
    local audio_filename=$(echo "$curl_output" | grep -oP 'Location: .*?name=\K[^ ]+' | tr -d '\r')

    if [ -z "$audio_filename" ]; then
        echo "Error: Unable to retrieve audio URL."
        exit 1
    fi

    echo "$audio_filename"
}

# Function to download and play audio
play_audio() {
    local audio_url="$1"
    local output_filename=$(basename "$audio_url")

    curl -o "$output_filename" -s "$audio_url"
    aplay "$output_filename"
    # rm -f "$output_filename"
}

# Check for the correct number of arguments
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: $0 <text_to_synthesize> [voice]"
    echo "Available voice options: female, male"
    exit 1
fi

# Command-line arguments
text_to_synthesize="$1"
if [ "$2" == "female" ]; then
    voice="hts_tamil_female"
elif [ "$2" == "male" ]; then
    voice="hts_tamil_male"
fi

# Get the audio URL and play the audio
audio_url=$(get_audio_url "$text_to_synthesize" "$voice")
play_audio "$AUDIO_BASE_URL/$audio_url" 
