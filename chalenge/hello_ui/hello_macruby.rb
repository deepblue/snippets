require 'hotcocoa'
include HotCocoa

alert = Proc.new {
  NSAlert.alertWithMessageText("I'm MacRuby", 
    defaultButton: "OK", 
    alternateButton: "Cancel", 
    otherButton: nil, 
    informativeTextWithFormat: "HotCocoa").
  runModal
}

application do |app|
  window :frame => [100, 100, 100, 60], :title => "MacRuby!"  do |win|
    win << button(:title => "Hello!", :on_action => alert)
  end
end
