require 'csv'

CSV.generate(encoding: Encoding::SJIS, row_sep: "\r\n", force_quotes: true) do |csv|
  csv_column_names = %w(名前 メールアドレス フォロー数 フォロワー数 登録日 更新日)
  csv << csv_column_names
  @users.each do |user|
    column_values = [
      user.name,
      user.email,
      user.following.count,
      user.followers.count,
      user.created_at.strftime('%Y%m%d'),
      user.updated_at.strftime('%Y%m%d')
    ]
    csv << column_values
  end
end