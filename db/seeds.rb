# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

#Semester.create!( :full_name => 'Summer 2013', :code => '201300', :date_begin => 2.months.ago, :date_end => 1.month.from_now)
Semester.create!( :full_name => 'Summer 2013', :code => '201220', :date_begin => 5.months.ago, :date_end => 1.month.ago)
Semester.create!( :full_name => 'Fall 2013', :code => '201310', :date_begin => 1.month.ago, :date_end => 5.months.from_now)


FairUseQuestion.add_new_question!('Teaching (including multiple copies for classroom use)', 'Purpose', 1, true)
FairUseQuestion.add_new_question!('Research', 'Purpose', 2, true)
FairUseQuestion.add_new_question!('Scholarship', 'Purpose', 3, true)
FairUseQuestion.add_new_question!('Nonprofit Education', 'Purpose', 4, true)
FairUseQuestion.add_new_question!('Criticism', 'Purpose', 5, true)
FairUseQuestion.add_new_question!('Comment', 'Purpose', 6, true)
FairUseQuestion.add_new_question!('News reporting', 'Purpose', 7, true)
FairUseQuestion.add_new_question!('Transformative or productive use (changes the worf for new utility)', 'Purpose', 8, true)
FairUseQuestion.add_new_question!('Restricted access (to students or other appropriate group)', 'Purpose', 9, true)
FairUseQuestion.add_new_question!('Parody', 'Purpose', 10, true)
FairUseQuestion.add_new_question!('Comercial activity', 'Purpose', 11, false)
FairUseQuestion.add_new_question!('Profiting from the use', 'Purpose', 12, false)
FairUseQuestion.add_new_question!('Entertainment', 'Purpose', 13, false)
FairUseQuestion.add_new_question!('Bad-faith behavior', 'Purpose', 14, false)
FairUseQuestion.add_new_question!('Denying credit to original author', 'Purpose', 15, false)
FairUseQuestion.add_new_question!('Published work', 'Nature', 16, true)
FairUseQuestion.add_new_question!('Factual or nonfiction based', 'Nature', 17, true)
FairUseQuestion.add_new_question!('Important to favored educational objectives', 'Nature', 18, true)
FairUseQuestion.add_new_question!('Unpublished work', 'Nature', 19, false)
FairUseQuestion.add_new_question!('Highly creative work (art, music, novels, films, plays)', 'Nature', 20, false)
FairUseQuestion.add_new_question!('Fiction', 'Nature', 21, false)
FairUseQuestion.add_new_question!('Small quantity', 'Amount', 22, true)
FairUseQuestion.add_new_question!('Portion used is not central or significant to entire work', 'Amount', 23, true)
FairUseQuestion.add_new_question!('Amount is appropriate for favored educational purpose', 'Amount', 24, true)
FairUseQuestion.add_new_question!('Large portion or whole work used', 'Amount', 25, false)
FairUseQuestion.add_new_question!('Portion used is central to or "heart of the work"', 'Amount', 26, false)
FairUseQuestion.add_new_question!('User owns lawfully purchased or acquired copy of original work', 'Effect', 27, true)
FairUseQuestion.add_new_question!('One or few copies made', 'Effect', 28, true)
FairUseQuestion.add_new_question!('No significant effect on the market or potential for copyrighted work', 'Effect', 29, true)
FairUseQuestion.add_new_question!('No similar product marketed by the copyright holder', 'Effect', 30, true)
FairUseQuestion.add_new_question!('Lack of licensing mechanism', 'Effect', 31, true)
FairUseQuestion.add_new_question!('Could replace sale of copyrighted work', 'Effect', 32, false)
FairUseQuestion.add_new_question!('Significant impairs market or potential market for copyrighted work or derivative', 'Effect', 33, false)
FairUseQuestion.add_new_question!('Reasonably available licensing mechanism for use of the copyrighted work', 'Effect', 34, false)
FairUseQuestion.add_new_question!('Affordable permission available for using work', 'Effect', 35, false)
FairUseQuestion.add_new_question!('Numerous copies made', 'Effect', 36, false)
FairUseQuestion.add_new_question!('You made it accessible on the Web or in other public forum', 'Effect', 37, false)
FairUseQuestion.add_new_question!('Repeated or long-term use', 'Effect', 38, false)


