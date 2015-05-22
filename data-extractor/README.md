# Data Extractor

##  To extract move sequences from velena logs
    
    sh extract_strings.sh <path_to_log_file>

##  To decode move sequences to board csv

    virtualenv venv
    source venv/bin/activate
    pip install -r requirements.txt
    python data-extractor.py <path_to_input_file> <path_to_output_file>