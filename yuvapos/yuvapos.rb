require "roda"
require "sequel"
require "bcrypt"
require "rack/protection"

database = "yuvapos"
user     = "postgres"#ENV["PGUSER"]
password = "secret123"#ENV["PGPASSWORD"]
DB = Sequel.connect(adapter: "postgres", database: database, host: "127.0.0.1", user: user, password: password)

class Yuvapos < Roda
	Sequel::Model.plugin :validation_helpers
	use Rack::Session::Cookie, secret: "some_nice_long_random_string_DSKJH4378EYR7EGKUFH", key: "_yuvapos_session"
	use Rack::Protection

  require './models/user.rb'
  require './models/product.rb'
  require './models/sale_detail.rb'

	plugin :csrf
  
  plugin :public, :gzip=>true
  plugin :not_found
  plugin :error_handler
  #plugin :render, :escape=>:erubi
  plugin :render
  plugin :static, ["/images", "/css", "/js"]
  plugin :assets,
    :css=>%w'bootstrap.min.css jquery.autocomplete.css scaffold_associations_tree.css spam.scss',
    :js=>%w'jquery-1.11.1.min.js bootstrap.min.js jquery.autocomplete.js autoforme.js application.js scaffold_associations_tree.js',
    :css_opts=>{:style=>:compressed, :cache=>false},
    :compiled_js_dir=>'javascripts',
    :compiled_css_dir=>'stylesheets',
    :compiled_path=>nil,
    :precompiled=>File.expand_path('../compiled_assets.json', __FILE__),
    :prefix=>nil,
    :gzip=>true

  plugin :render_each
  plugin :flash
  plugin :h
  plugin :json
  plugin :symbol_views
  plugin :symbol_matchers


  plugin :head 

  plugin :autoforme do
    inline_mtm_associations :all
    association_links :all_except_mtm

    model Product do
      class_display_name 'Product'
      columns [:name, :price]
    end

    model SaleDetail do
      class_display_name 'Entry'
      columns [:product_id, :qty, :rate, :total]
    end
  end

  ::Forme.register_config(:mine, :base=>:default, :labeler=>:explicit, :wrapper=>:div)
  ::Forme.default_config = :mine

  route do |r|
   # r.public

  r.root do
    view("homepage")
  end

  r.post do
#        r.is 'add_entry' do
          
          @products = Product.all
          @sale_detail = SaleDetail.new
          save_entry
          if json_requested?
            [
              ['set_value', '#selected_entry_id', ''],
              ['replace_html', '#new_entry', render('_new_product_entry')],
              ['insert_html', '#new_entry', "<tr id='entry_#{@entry.id}'>#{render('_register_entry', :locals=>{:entry=>@entry})}</tr>"],
              ['replace_html', '#results', 'Added entry'],
              ['autocompleter'],
              ['resort']
            ]
          else
            r.redirect "/products/new"
          end
 #       end
  end




  r.get "login" do
      view("login")
    end

    r.post "login" do
      if user = User.authenticate(r["email"], r["password"])
        session[:user_id] = user.id
        r.redirect "/"
      else
        r.redirect "/login"
      end
    end
    
    r.post "logout" do
      session.clear
      r.redirect "/"
    end

        r.get /products\/([0-9]+)/ do |id|
        	@product = Product[id]
        	view("products/show")
        end

        r.on "products", :method=>:get do
          r.is 'new' do
        		@product = Product.new
            @xyz = Product.all
        		#view("products/new")

            if json_requested?
            [
              ['set_value', '#selected_entry_id', ''],
              ['replace_html', '#new_entry', render('_new_product_entry')],
              ['insert_html', '#new_entry', "<tr id='entry_#{@entry.id}'>#{render('_register_entry', :locals=>{:entry=>@entry})}</tr>"],
              ['replace_html', '#results', 'Added entry'],
              ['autocompleter'],
              ['resort']
            ]
          else
            #r.redirect "/products/new"
            :"products/new"
          end

        	end

        r.post do
        	@product = Product.new(r["product"])
          @xyz = Product.all
        	#if @product.valid? && @product.save

            if json_requested?
            [
              ['set_value', '#selected_entry_id', ''],
              ['replace_html', '#new_entry', render('_new_product_entry')],
              ['insert_html', '#new_entry', "<tr id='entry_#{@entry.id}'>#{render('_register_entry', :locals=>{:entry=>@entry})}</tr>"],
              ['replace_html', '#results', 'Added entry'],
              ['autocompleter'],
              ['resort']
            ]
          else
            #r.redirect "/products/new"
            :new
          end







        		#r.redirect "/"
        		#else
        		#view("products/new")
        	#end
	      end
        
        end

    
    r.on "users" do
      
      r.get "new" do
      	@user = User.new
        view("users/new")
      end

      r.get ":id" do |id|
        @user = User[id]
        view("users/show")
      end

      r.is do
        r.get do
          @users = User.order(:id)
          view("users/index")
      end
      r.post do
          @user = User.new(r["user"])
          if @user.valid? && @user.save
            r.redirect "/users"
          else
            view("users/new")
          end
      end

end #r.is do
end #r.on "users" do

autoforme

end

  def save_entry
    r=request
    @sale_detail.product_id = r['product_id']
    @sale_detail.rate = r['rate']
    @sale_detail.qty=r['qty']
    @sale_detail.total = r['total']
    @sale_detail.save
  end

    def json_requested?
    env['HTTP_ACCEPT'] =~ /application\/json/
  end

end

#run Yuvapos.freeze.app