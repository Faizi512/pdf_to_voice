require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      book = Book.create(title: 'Sample Book', author: 'Author Name')
      get :show, params: { id: book.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    it 'creates a new book' do
      expect {
        post :create, params: { book: { title: 'New Book', author: 'New Author' } }
      }.to change(Book, :count).by(1)
    end
  end

  describe 'PATCH #update' do
    it 'updates an existing book' do
      book = Book.create(title: 'Old Title', author: 'Old Author')
      patch :update, params: { id: book.id, book: { title: 'Updated Title' } }
      book.reload
      expect(book.title).to eq('Updated Title')
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the book' do
      book = Book.create(title: 'Book to be deleted', author: 'Author')
      expect {
        delete :destroy, params: { id: book.id }
      }.to change(Book, :count).by(-1)
    end
  end
end