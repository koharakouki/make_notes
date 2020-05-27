# # 絶対パスから相対パス指定
# env :PATH, ENV['PATH']
# # ログファイルの出力先
# set :output, 'log/cron.log'
# # ジョブの実行環境を本番環境に指定
# set :environment, :production

# every 1.month, at: 'start of the month at 0am' do
#   runner 'User.send_everymonth_mail'
# end

# every 1.minutes do
#   runner 'User.send_everymonth_mail'
# end
