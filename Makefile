documentation:
    @jazzy \
        --clean \
        --author dragosrobertn \
        --author_url https://dragosneagu.com \
        --github_url https://github.com/dragosrobertn/KNContacts \
        --xcodebuild-arguments -scheme,KNContacts \
        --module KNContacts \
        --documentation = ./*md
        --output ./docs
    @rm -rf ./build