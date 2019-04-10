def create_seed_user
  email = Faker::Internet.safe_email
  @user = User.find_or_create_by(email: email)
  @user.password = "test1234"
  if @user.save
    p "User #{email} created"
    return @user
  else
    return nil
  end
end

Comment.all.destroy_all
Article.all.destroy_all
User.all.destroy_all

for i in 1..100
  @article = Article.new
  @article.title = "Will #{Faker::Company.name} really #{Faker::Company.bs}?"
  paragraph_1 = Faker::Lorem.paragraphs.join(' ')
  paragraph_2 = Faker::Lovecraft.paragraphs.join(' ')
  paragraph_3 = Faker::Hipster.paragraphs.join(' ')
  @article.content = "#{paragraph_1} <br /> #{paragraph_2} <br /> #{paragraph_3}"
  @article.user = create_seed_user
  if @article.save
    p "#{@article.title} has been saved"
    for ii in 1..10
      @comment = Comment.new
      @comment.article = @article
      @comment.message = Faker::Hacker.say_something_smart
      @comment.user = create_seed_user
      if @comment.save
        p "Comment #{ii} has been saved for article #{@article.title}"
      else
        p @comment.errors
      end
    end
  else
    p @article.errors
  end
end