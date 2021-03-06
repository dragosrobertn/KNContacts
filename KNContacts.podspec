Pod::Spec.new do |s|

  s.name         = "KNContacts"
  s.version      = ENV['LIB_VERSION'] || "1.2.3"
  s.summary      = "KNContacts is a wrapper framework for CNContacts for easier access, scheduling and ordering."

  s.description  = <<-DESC 
                          KNContacts is a wrapper framework for CNContacts for easier access to contact information, 
                          with classes to craete contact list, create contacts scheduling and options for ordering.
                   DESC

  s.homepage     = "https://github.com/dragosrobertn/KNContacts"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = "dragosrobertn"
  s.social_media_url   = "http://twitter.com/dragosrobertn"

  s.swift_version = '5.0'
  s.platform     = :ios, "10.0"

  s.source       = { :git => "https://github.com/dragosrobertn/KNContacts.git", :tag => s.version }
  s.source_files  = "Sources/*.swift"

end
