# encoding: utf-8
require 'spec_helper'
require 'pairtree'

describe "Pairtree encoding" do

  def roundtrip(id, expected_encoded=nil, expected_path=nil)
    encoded = Pairtree::Identifier.encode(id)
    unless expected_encoded.nil?
      encoded.should == expected_encoded
    end
    unless expected_path.nil?
      path = Pairtree::Path.id_to_path(id)
      path.should == expected_path
    end
    str = Pairtree::Identifier.decode(encoded)
    
    if str.respond_to? :force_encoding
      str.force_encoding("UTF-8")
    end
    
    str.should == id
  end
  
  it "should handle a" do
    roundtrip('a', 'a', 'a/a')
  end

  it "should handle ab" do
    roundtrip('ab', 'ab', 'ab/ab')
  end

  it "should handle abc" do
    roundtrip('abc', 'abc', 'ab/c/abc')
  end

  it "should handle abcd" do
    roundtrip('abcd', 'abcd', 'ab/cd/abcd')
  end

  it "should handle space" do
    roundtrip('hello world', 'hello^20world', 'he/ll/o^/20/wo/rl/d/hello^20world')
  end

  it "should handle slash" do
    roundtrip("/","=",'=/=')
  end

  it "should handle urn" do
    roundtrip('http://n2t.info/urn:nbn:se:kb:repos-1','http+==n2t,info=urn+nbn+se+kb+repos-1','ht/tp/+=/=n/2t/,i/nf/o=/ur/n+/nb/n+/se/+k/b+/re/po/s-/1/http+==n2t,info=urn+nbn+se+kb+repos-1')
  end
  
  it "should handle wtf" do
    roundtrip('what-the-*@?#!^!?', "what-the-^2a@^3f#!^5e!^3f", "wh/at/-t/he/-^/2a/@^/3f/#!/^5/e!/^3/f/what-the-^2a@^3f#!^5e!^3f")
  end

  it "should handle special characters" do
    roundtrip('\\"*+,<=>?^|', "^5c^22^2a^2b^2c^3c^3d^3e^3f^5e^7c")
  end
  
  it "should roundtrip hardcore Unicode" do
    roundtrip(%{
       1. Euro Symbol: €.
       2. Greek: Μπορώ να φάω σπασμένα γυαλιά χωρίς να πάθω τίποτα.
       3. Íslenska / Icelandic: Ég get etið gler án þess að meiða mig.
       4. Polish: Mogę jeść szkło, i mi nie szkodzi.
       5. Romanian: Pot să mănânc sticlă și ea nu mă rănește.
       6. Ukrainian: Я можу їсти шкло, й воно мені не пошкодить.
       7. Armenian: Կրնամ ապակի ուտել և ինծի անհանգիստ չըներ։
       8. Georgian: მინას ვჭამ და არა მტკივა.
       9. Hindi: मैं काँच खा सकता हूँ, मुझे उस से कोई पीडा नहीं होती.
      10. Hebrew(2): אני יכול לאכול זכוכית וזה לא מזיק לי.
      11. Yiddish(2): איך קען עסן גלאָז און עס טוט מיר נישט װײ.
      12. Arabic(2): أنا قادر على أكل الزجاج و هذا لا يؤلمني.
      13. Japanese: 私はガラスを食べられます。それは私を傷つけません。
      14. Thai: ฉันกินกระจกได้ แต่มันไม่ทำให้ฉันเจ็บ "
    })
  end
  
  it "should roundtrip French" do
    roundtrip('Années de Pèlerinage')
    roundtrip(%{
      Années de Pèlerinage (Years of Pilgrimage) (S.160, S.161,
      S.163) is a set of three suites by Franz Liszt for solo piano. Liszt's
      complete musical style is evident in this masterwork, which ranges from
      virtuosic fireworks to sincerely moving emotional statements. His musical
      maturity can be seen evolving through his experience and travel. The
      third volume is especially notable as an example of his later style: it
      was composed well after the first two volumes and often displays less
      showy virtuosity and more harmonic experimentation.
    })
 end
  
end
