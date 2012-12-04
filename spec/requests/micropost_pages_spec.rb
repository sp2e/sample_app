require 'spec_helper'

describe "Micropost pages" do

  subject { page }
  User.delete_all 
#above line may or may not be helping make test more robust

  let(:user) { FactoryGirl.create(:user) }
  #     raise user.inspect
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') } 
      end
    end

    describe "with valid information" do
      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end #describe "with valid information"  

    describe "pagination" do

      before(:all) { 31.times { FactoryGirl.create(:micropost, user: user) } }
      #raise user.inspect
      #before(:all) { FactoryGirl.create(:micropost, user: user) }
      after(:all)  { Micropost.delete_all }

      #after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list content of each micropost" do
        Micropost.paginate(page: 1).each do |micropost|
          page.should have_selector('li', text: micropost.content)
          #puts micropost.content 
        end
      end   
    end #describe "pagination"
  end #describe "micropost creation" 

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end #describe "as correct user"
  end #describe "micropost destruction"
end