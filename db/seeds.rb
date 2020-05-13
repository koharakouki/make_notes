Admin.create!(
  email: "admin@example.com",
	password: "password"
)

User.create!(
	name: "春日",
	email: "kasuga@example.com",
	password: "kasuga",
	introduction: "春日です" * 10
)

User.create!(
	name: "若林",
	email: "wakaba@example.com",
	password: "wakaba",
	introduction: "若林です" * 10
)

30.times do |n|
  User.create!(
    email: "test#{n + 1}@test.com",
    name: "テスト太郎#{n + 1}",
    password: "password",
    introduction: "自己紹介" * 10
  )
end

20.times do |n|
  User.create!(
    email: "#{n + 1}test@test.com",
    name: "テスト二郎#{n + 1}",
    password: "password",
    introduction: "自己紹介" * 10,
    created_at: DateTime.strptime("05/#{rand(01..31)}/2020 #{rand(00..23)}:30", '%m/%d/%Y %H:%M')
  )
end

User.all.each do |user|
  user.articles.create!(
    article_title: 'タイトル',
    content: 'テキストテキストテキストテキスト' * 10,
    user_id: user.id
  )
end

User.all.each do |user|
	Article.all.each do |article|
		ArticleComment.create!(
			user_id: user.id,
			article_id: article.id,
			content: "コメント" * 10
		)
	end
end

User.all.each do |user|
	Article.all.each do |article|
		Favorite.create!(
			user_id: user.id,
			article_id: article.id,
		)
	end
end


[Genre.create!(
	user_id: 1,
	name: "映画"
),
Genre.create!(
	user_id: 1,
	name: "テレビ"
),
Genre.create!(
	user_id: 1,
	name: "音楽"
),
Genre.create!(
	user_id: 1,
	name: "本"
),
Genre.create!(
	user_id: 1,
	name: "漫画"
),
Genre.create!(
	user_id: 1,
	name: "ラジオ"
)]


[Genre.create!(
	user_id: 2,
	name: "映画"
),
Genre.create!(
	user_id: 2,
	name: "テレビ"
),
Genre.create!(
	user_id: 2,
	name: "音楽"
),
Genre.create!(
	user_id: 2,
	name: "本"
),
Genre.create!(
	user_id: 2,
	name: "漫画"
),
Genre.create!(
	user_id: 2,
	name: "ラジオ"
)]

n = 0

50.times do
	User.first(2).each do |user|
		user.genres.each do |genre|
				List.create!(
					user_id: user.id,
					title: "タイトル#{n += 1}",
					genre_id: genre.id,
					is_watched: false
				)
		end
	end
end

50.times do
	User.first(2).each do |user|
		user.genres.each do |genre|
				List.create!(
					user_id: user.id,
					title: "タイトル#{n += 1}",
					genre_id: genre.id,
					rate: rand(0..5),
					start_time: DateTime.strptime("05/#{rand(01..31)}/2020 #{rand(00..23)}:30", '%m/%d/%Y %H:%M'),
					is_watched: true
				)
		end
	end
end

users = User.all
@user  = users.first
@user_second = users.second
following = users[2..20]
followers = users[3..15]
following.each { |followed| @user.follow(followed) }
followers.each { |follower| follower.follow(@user) }

following.each { |followed| @user_second.follow(followed) }
followers.each { |follower| follower.follow(@user_second) }



















