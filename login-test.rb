# coding: utf-8
require 'mechanize'

Id       = 'id'
Password = 'password'

Mechanize.new do |agent|
  agent.user_agent = 'Mozilla/5.0 (Linux; U; Android 2.3.2; ja-jp; SonyEricssonSO-01C Build/3.0.D.2.79) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1'

  agent.get 'http://login.yahoo.co.jp/config/login?.lg=jp&.intl=jp&logout=1&.src=www&.done=http://www.yahoo.co.jp'

  sleep 3
  agent.get 'https://login.yahoo.co.jp/config/login?.src=www&.done=http://www.yahoo.co.jp'
  agent.page.form_with(name: 'login_form') do |form|
    form.field_with(name: 'login').value = Id
    form.field_with(name: 'passwd').value = Password
    agent.page.body =~ /\("\.albatross"\)\[0\]\.value = "(.*)"/
    form.field_with(name: '.albatross').value = $1
    form.click_button
  end

  sleep 3
  agent.get 'http://yahoo.co.jp'
  # ログインに成功してたらログアウトが存在するはず
  puts true if agent.page.body =~ /ログアウト/
end
