## Setup

1. Update .env file with your OpenAI key

2. Install ruby rails 7.1

Download and install ruby 3.x https://rubyinstaller.org/
Download and install rails 7.x from https://railsinstaller.dev/
```
git clone https://github.com/ceeyem/askmybook
```

3. Check ruby and rails version

```
$ rails -v
Rails 7.1.2
$ ruby -v
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [x64-mingw-ucrt
```
4. Install gems for rails server
```
cd askmybook
bundle install
```

5. Install gems for PDF embeddings script
```
cd askmybook/scripts
bundle install
```

6. Turn your PDF into embeddings for GPT-3:
```
cd askmybook/scripts
bundle install
ruby scripts/pdf_to_pages_embeddings.rb --pdf book.pdf
```

7. Set up database tables and collect static files:
```
rails db:create
rails db:migrate
```

8. Seed database with dashboard admin password and username and some dummy QA
```
rails db:seed
```

## Deploy to fly.io

```
cd askmybook
flyctl launch
fly deploy
```

### Run locally

```
rails s 
```
Server will start on http://localhost:3000
