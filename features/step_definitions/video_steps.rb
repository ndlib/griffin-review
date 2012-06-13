Given /^I have a video titled (.+)$/ do |title|
  @video = Video.create!(:title => title, :item_type => 'video', :url => 'http://my.fake.url') 
end

When /^I go to the pertinent video page$/ do
  video_id = @video.item_id
  visit "/videos/#{video_id}" 
end

Then /^I should see "([^"]*)"$/ do |title|
  video_id = @video.item_id
  visit "/videos/#{video_id}" 
  page.should have_content title
end
