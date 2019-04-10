require 'rails_helper'

RSpec.describe "comments", type: :request do
  before(:each) do #This logins the user
    @user = FactoryBot.create(:user) # Create the user

    # Set up the basic premise of the test by making sure that you have to log in
    visit root_path
    expect(current_path).to eq(new_user_session_path)
    expect(current_path).to_not eq(root_path)

    # Within the form #new_user do the following
    # The reason I put this within a within block is so if there are 2 form fields
    # on the page called Email it will fill in only this one
    within('#new_user') do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log in'
    end

    # Since we've logged in we should check if the application redirected us to the right path
    expect(current_path).to eq(root_path)
    expect(current_path).to_not eq(new_user_session_path)
    expect(page).to have_content('Signed in successfully.')

    # Generate parent Article for Comment
    @article = FactoryBot.create(:article)
    visit articles_path
    click_link 'New Article'
    fill_in 'article_title', with: 'New_Article'
    fill_in 'article_content', with: 'New_content_with_a_lot_of_typing'
    select @user.email, from: 'article[user_id]'
    click_button 'Create Article'
    expect(page).to have_content('Article was successfully created.')
    expect(page).to have_content('New_Article')
    expect(page).to have_content('New_content_with_a_lot_of_typing')
    visit comments_path
  end

  #Comment Vail Index Test
  describe 'GET #index' do
    describe 'valid: ' do
      it "should return a list of comments" do
        @comment = FactoryBot.create(:comment)
        click_link 'Comments'
        expect(current_path).to eq(comments_path)

        expect(page).to have_content(@comment.message)
        # save_and_open_page
      end
    end

    describe 'invalid: ' do
      # there's no real invalid version of this test we skip it
    end
  end

  # Valid Show
    describe 'GET #show' do
      describe 'valid: ' do
        it 'should return a comment' do
          @comment = FactoryBot.create(:comment)
          click_link 'Comments'
          expect(current_path).to eq(comments_path)

          expect(page).to have_content(@comment.message)
          click_link "Show"
          expect(current_path).to eq(comment_path(@comment))

          expect(page).to have_content(@comment.message)
          expect(page).to have_content(@comment.user.email)
          # save_and_open_page
        end
      end
      #Invalid show
      describe 'invalid: ' do
        it 'should not return a comment if one does not exist' do
          visit comment_path(99999)
          expect(current_path).to eq(comments_path)
          expect(page).to have_content("The comment you're looking for cannot be found")
          #save_and_open_page
        end
      end
    end

  # Valid New Comment
  describe 'GET #new' do
    describe 'valid: ' do
      it 'should create a new comment with valid attributes' do
        click_link "Comments"
        expect(current_path).to eq(comments_path)

        click_link 'New Comment'
        expect(current_path).to eq(new_comment_path)

        fill_in 'comment_message', with: 'New_message_with_a_lot_of_typing'
        click_button 'Create Comment'
        # save_and_open_page
        expect(page).to have_content('Comment was successfully created.')
        expect(page).to have_content('New_message_with_a_lot_of_typing')
      end
    end

    #Invalid New Comment
    describe 'invalid: ' do
      it 'should not create a new comment with invalid attributes' do
        click_link "Comments"
        expect(current_path).to eq(comments_path)

        click_link 'New Comment'
        expect(current_path).to eq(new_comment_path)

        fill_in 'comment_message', with: ''
        click_button 'Create Comment'
        # save_and_open_page
        expect(page).to have_content("Message can't be blank")
      end
    end
  end

  # Valid Edit Comment
  describe 'GET #edit' do
    describe 'valid: ' do
      it 'should update an comment with valid attributes' do
        @comment = FactoryBot.create(:comment)
        click_link 'Comments'
        expect(current_path).to eq(comments_path)

        expect(page).to have_content(@comment.message)

        click_link "Show"
        expect(current_path).to eq(comment_path(@comment))

        expect(page).to have_content(@comment.message)

        click_link "Edit"
        expect(current_path).to eq(edit_comment_path(@comment))

        fill_in 'comment_message', with: 'Edited_comment_Message'
        click_button 'Update Comment'
        expect(page).to have_content('Comment was successfully updated.')
        expect(current_path).to eq(comment_path(@comment))
        # save_and_open_page
      end
    end

    # Invalid Edit Comment
    describe 'invalid: ' do
      it 'should not update an comment with invalid attributes' do
        @comment = FactoryBot.create(:comment)
        click_link 'Comments'
        expect(current_path).to eq(comments_path)

        click_link "Show"
        expect(current_path).to eq(comment_path(@comment))

        expect(page).to have_content(@comment.message)

        click_link "Edit"
        expect(current_path).to eq(edit_comment_path(@comment))

        fill_in 'comment_message', with: ''
        click_button 'Update Comment'
        expect(page).to have_content("Message can't be blank")
        # save_and_open_page
      end
    end
  end

  # Valid Destroy Comment
  describe "DELETE #destroy" do
    describe 'valid: ' do
      it 'should destroy an comment when destroy is clicked' do
        @comment = FactoryBot.create(:comment)
        click_link 'Comments'
        expect(current_path).to eq(comments_path)

        expect(page).to have_content(@comment.message)
        click_link 'Destroy'

        expect(current_path).to eq(comments_path)
        expect(page).to have_content("Comment was successfully destroyed.")
      end
    end
  end
end
