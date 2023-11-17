API format
----------

Voice options: hts_tamil_female, hts_tamil_male

.. code-block:: bash

   # Post Request
   curl -x POST -H 'Content-Type: application/x-www-form-urlencoded' \
   -d 'options=<voice_option>&word=<tamil_words>'

   # Header of above request will have wav file name.
   http://speech.ssn.edu.in/SpeechSynthesis/wav/<wav_file>


Bash script wrapper for TTS - `Link`_

  .. _Link: ./txt2speech.sh
