# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

When /^I have sorted by release date$/ do
    click_on 'Release Date'
end

When /^I have sorted by movie title$/ do
    click_on 'Movie Title'
end

Then /^I should see Aladdin before Amelie$/ do
    titles = all(:css, '#movies tbody tr td:nth-child(1)').map {|x| x.text}
    expect(titles.find_index('Aladdin') < titles.find_index('Amelie')).to be true
end

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
    new_movie = Movie.new(movie)
    new_movie.save
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  
  desired_ratings = arg1.split ', '
  
  all_ratings = ['G', 'PG', 'PG-13', 'R', 'NC-17']
  
  all_ratings.each do |x|
    find('#ratings_'+x).set false
  end
  
  desired_ratings.each do |x|
    find('#ratings_'+x).set true
  end
  
  click_button 'Refresh'
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
    desired_ratings = arg1.split ', '
    rows = all(:css, '#movies tbody tr')
    rows.each do |x|
        rating = x.find('td:nth-child(2)').text
        expect(desired_ratings).to include(rating)
    end
end

Then /^I should see all of the movies$/ do
  rows = all(:css, '#movies tbody tr')
  rows.length.should == Movie.all.length
end



