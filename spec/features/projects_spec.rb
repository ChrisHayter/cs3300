require 'rails_helper'

def login_user
  user = FactoryBot.create(:user)
  login_as(user)
end

RSpec.feature "Projects", type: :feature do

  # context "Login" do
  #   scenario "should sign up" do
  #     visit root_path
  #     click_link 'New Project'
  #     click_link 'Sign Up'
  #     within("form") do
  #       fill_in "Email", with: "test@user.com"
  #       fill_in "Password", with: "qwerty"
  #       fill_in "Password confirmation", with: "qwerty"
  #       click_button "Sign up"
  #     end
  #     expect(page).to have_content("Welcome! You have signed up successfully.")
  #   end

  #   scenario "should log in" do
  #     login_user
  #     visit root_path
  #     expect(page).to have_content("Logged in")
  #   end
  # end


  context "Create new project" do
    before(:each) do
      login_user
      visit new_project_path
      fill_in "Title", with: "Test title"
    end

    scenario "should be successful" do
      fill_in "Description", with: "Test description"
      click_button "Submit"
      expect(page).to have_content("Project was successfully created")
    end

    scenario "should fail" do
      click_button "Submit"
      expect(page).to have_content("Description can't be blank")
    end
  end

  context "Update project" do
    let(:project) { Project.create(title: "Test title", description: "Test content") }
    before(:each) do
      login_user
      visit edit_project_path(project)
    end

    scenario "should be successful" do
      fill_in 'Title', with: 'New title content'
      fill_in "Description", with: "New description content"
      click_button "Submit"
      expect(page).to have_content("Project was successfully updated")
    end

    scenario "should fail" do
      fill_in "Description", with: ""
      click_button "Submit"
      expect(page).to have_content("Description can't be blank")
    end
  end

  context "Remove existing project" do
    let!(:project) { Project.create(title: "Test title", description: "Test content") }
    scenario "remove project" do
      login_user
      visit projects_path
      click_link "Destroy"
      expect(page).to have_content("Project was successfully destroyed")
      expect(Project.count).to eq(0)
    end
  end
end

