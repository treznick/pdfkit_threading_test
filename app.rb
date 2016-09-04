require "sinatra"
require "pdfkit"

use PDFKit::Middleware

get "/docs/:id" do
  erb "docs.html".to_sym , locals: { id: params[:id] }
end
