Pod::Spec.new do |s|
  s.name                = 'ArabicDictionary'
  s.version             = '0.1.0'
  s.license             = { :type => 'MIT' }
  s.homepage            = 'https://github.com/dominostars/ArabicDictionary'
  s.authors             = { 'Gilad Gurantz' => 'ggurantz@gmail.com' }
  s.summary             = 'Basic Modern Standard Arabic dictionary for iOS and OS X.'
  s.source              = { :git => 'https://github.com/ggurantz/ArabicDictionary.git' }
  s.source_files        = "ArabicDictionary.h"
  s.public_header_files = "ArabicDictionary.h"

  s.subspec 'Core' do |ss|
    ss.source_files	    = "Classes/**/*.{h,m,swift}"
    ss.resources        = "Resources/*"
  end
end
