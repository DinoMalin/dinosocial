Reseau social:

- docker compose
- front: React/Next
- back: Nodejs
- db: Postgresql
- tests unitaires: api rest

Api:

- Get auth token

- Account:
    - Create DONE
    - Delete
    - Modify DONE
    - Connect DONE
    - Follow DONE
    - Unfollow DONE
    - Disconnect
GET:
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

TODO:
- validators pour eviter la repetition de conditions
