Bullet.add_whitelist type: :n_plus_one_query, class_name: 'Notification', association: :articles
Bullet.add_whitelist :type => :unused_eager_loading, :class_name => "Notification", :association => :articles