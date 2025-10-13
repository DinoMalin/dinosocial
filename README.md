Reseau social:
- k3s
- front: React/Next
- back: Nodejs
- db: Postgresql
- tests unitaires: api rest

Cahier des charges:
1/ Setup db
2/ Setup api rest en node
3/ Creer tests unitaires
4/ Conteneriser db, api et tests
5/ Script de creation de data placeholder: dans les tests ?
6/ Setup front Nextjs/React basique

Api:
- Get auth token

- Account:
    - Create /
    - Delete
    - Modify /
    - Connect /
    - Follow /
    - Unfollow /
    - Disconnect / gere cote front uniquement
Get:
    - Get profile
    - Get followers
    - Get following
    - Get posts
    - Get reposts
    - Get liked posts

- Post:
    - Create
    - Delete
    - Answer
    - Like
    - Unlike
    - Repost
    - Unrepost
Get:
    - Get post (content, date, nb likes, nb reposts, nb answers)
    - Get likes (every user)
    - Get reposts (every user)
    - Get answers

DB:
- Account:
    - Pseudo -> text
    - Password -> hash
    - Avatar -> image
    - Posts -> [Post]
    - Lang -> text
    - Liked posts -> [Post]
    - Reposted posts -> [Post]
    - Creation_date -> Date
    - Followers -> [Account]
    - Following -> [Account]

- Post:
    - Content -> text
    - Author -> Account
    - Likes -> [Account]
    - Reposts -> [Account]
    - Answers -> [Post]
    - Parent -> Post
    - Creation_date -> date

demain:
    - tests follow/unfollow

remplacer les findOne where id: machin par findbyPk
