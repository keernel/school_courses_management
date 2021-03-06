require 'rails_helper'

feature 'School features' do

  let(:school) { build(:school) }

  scenario 'user list schools' do
    school = create(:school) 
    visit schools_path

    expect(page).to have_content(school.name)
  end

  scenario 'user see a school' do
    school = create(:school) 
    visit school_path(school)

    expect(page).to have_content(school.name)
  end

  scenario 'user create a new valid school' do
    visit new_school_path(school)

    fill_in 'Name', with: school.name
    fill_in 'Owner email', with: school.owner_email
    fill_in 'Pitch', with: school.pitch 
    fill_in 'Subdomain', with: school.subdomain
    fill_in 'Date of creation', with: school.date_of_creation.strftime("%d/%m/%Y")
    
    click_button 'Create School'

    expect(page).to have_content('Escola criada com sucesso.')
    expect(page).to have_content(school.name)
  end

  scenario 'user try to create a school with invalid inputs and get an error message' do
    visit new_school_path(school)

    fill_in 'Pitch', with: school.pitch 
    fill_in 'Subdomain', with: school.subdomain
    fill_in 'Date of creation', with: school.date_of_creation.strftime("%d/%m/%Y")
    
    click_button 'Create School'

    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Owner email can't be blank")
  end

  scenario 'user delete a school' do
    school = create(:school) 
    visit school_path(school)
    click_on 'Delete'

    expect(page).to have_content('Escola excluida com sucesso.')
  end

  scenario 'user update a school' do
    school = create(:school) 
    visit edit_school_path(school)
    
    fill_in 'Name', with: Faker::StarWars.character
    click_on 'Update School'

    expect(page).to have_content('Escola atualizada com sucesso.')
  end

  scenario 'user try to update a school with invalid input' do
    school = create(:school) 
    visit edit_school_path(school)
    
    fill_in 'Name', with: nil
    click_on 'Update School'

    expect(page).to have_content("Name can't be blank")
  end

  scenario 'user filter schools by name' do
    school = create(:school, name: 'USP')
    FactoryGirl.create_list(:school, 4)

    visit schools_path

    page_schools = page.all(:css, 'tr').length - 1
    expect(page_schools).to equal(5)

    fill_in 'name', with: 'USP' 
    find('button[type="submit"]').click

    page_schools = page.all(:css, 'tr').length - 1
    expect(page_schools).to equal(1)
    expect(page).to have_content('USP')
  end

  scenario 'user filter schools by email' do
    school = create(:school, name: "USP", owner_email: "email@example.com")
    FactoryGirl.create_list(:school, 4)

    visit schools_path
    
    page_schools = page.all(:css, 'tr').length - 1
    expect(page_schools).to equal(5)

    fill_in 'owner_email', with: 'email@example.com' 
    find('button[type="submit"]').click

    page_schools = page.all(:css, 'tr').length - 1
    expect(page_schools).to equal(1)
    expect(page).to have_content('USP')
  end

  scenario 'user get active students report' do
    FactoryGirl.create_list(:school, 4)
    school = School.first

    visit schools_active_students_path

    expect(page).to have_content(school.active_students)

  end


end
