require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザー新規登録ができるとき' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # トップページ移動
      visit root_path
      # トップページにサインアップページ遷移ボタンあること確認
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動
      visit new_user_registration_path
      # ユーザー情報を入力
      fill_in 'Nickname', with: @user.nickname
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      fill_in 'Password confirmation', with: @user.password_confirmation
      # サインアップボタンを押し、ユーザーモデルのカウントが1上がることを確認
      expect{
        find('input[name="commit"]').click
        sleep 1
      }.to change { User.count }.by(1)
      # トップページへ遷移
      expect(page).to have_current_path(root_path)
      # カーソル合わせ、ログアウトボタンが表示確認
      expect(
        find('.user_nav').find('span').hover
      ).to have_content('ログアウト')
      # サインアップページボタン・ログインボタンが非表示確認
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
    # トップページへ遷移
    visit root_path
    # トップページにサインアップページあること確認
    expect(page).to have_content('新規登録')
    # 新規登録ページへ移動
    visit new_user_registration_path
    # ユーザー情報入力
    fill_in 'Nickname', with: ''
    fill_in 'Email', with: ''
    fill_in 'Password', with: ''
    fill_in 'Password confirmation', with: ''
    # サインアップボタン押下、ユーザーモデルのカウントが上がらないことを確認
    expect{
      find('input[name="commit"]').click
      sleep 1
    }.to change { User.count }.by(0)
    # 新規登録ページへ戻されること確認
    expect(page).to have_current_path(new_user_registration_path)
    end
  end
end

RSpec.describe 'ログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context 'ログインができるとき' do
    it '保存されているユーザーの情報と合致すればログインができる' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # 正しいユーザー情報を入力する
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(page).to have_current_path(root_path)
      # カーソルを合わせるとログアウトボタンが表示されることを確認する
      expect(
        find('.user_nav').find('span').hover
      ).to have_content('ログアウト')
      # サインアップページへ遷移するボタンやログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end

  context 'ログインができないとき' do
    it '保存されているユーザーの情報と合致しないとログインができない' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページへ戻されることを確認する
      expect(page).to have_current_path(new_user_session_path)
    end
  end
end