require 'rails_helper'

RSpec.describe "Api::V1::Forms", type: :request do
  describe "GET /forms" do
    context "With invalid authentication headers" do
      it_behaves_like :deny_without_authorization, :get, "/api/v1/forms"
    end

    context "With valid authentication headers" do
      before do
        @user = create(:user)
        @form1 = create(:form, user: @user)
        @form2 = create(:form, user: @user)

        get "/api/v1/forms", params: {}, 
          headers: header_with_authentication(@user)
      end

      it "returns Request OK" do
        expect_status(200)
      end

      it "returns form list with two forms" do
        expect(json.count).to eql(2)
      end

      it "returned forms have right datas" do
        expect(json[0]).to eql(JSON.parse(@form1.to_json))
        expect(json[1]).to eql(JSON.parse(@form2.to_json))
      end
    end
  end

  describe "GET /forms/:friendly_id" do
    before do
      @user = create(:user)
    end

    context "When form exists" do

      context "is enabled" do
        before do
          @form = create(:form, user: @user, enable: true)
        end

        it "returns Request OK" do
          get "/api/v1/forms/#{@form.friendly_id}", params: {}, 
            headers: header_with_authentication(@user)
          expect_status(200)
        end

        it "returned form with right datas" do
          get "/api/v1/forms/#{@form.friendly_id}", params: {}, 
            headers: header_with_authentication(@user)
          expect(json).to eql(JSON.parse(@form.to_json))
        end
      end

      context "is disabled" do
        before do
          @form = create(:form, user: @user, enable: false)
        end

        it "returns Not Found" do
          get "/api/v1/forms/#{FFaker::Lorem.word}", params: {id: @form.friendly_id}, 
            headers: header_with_authentication(@user)
          expect_status(404)
        end
      end
    end

    context "When form doesn't exist" do
      it "returns Not Found" do
        get "/api/v1/forms/#{FFaker::Lorem.word}", params: {}, 
          headers: header_with_authentication(@user)
        expect_status(404)
      end
    end
  end

  describe "POST /forms" do

    context "With Invalid authentication headers" do
      it_behaves_like :deny_without_authorization, :post, "/api/v1/forms"
    end

    context "With valid authentication headers" do
      before do
        @user = create(:user)
      end

      context "with valid params" do
        before do
          @form_attributes = attributes_for(:form)
          post "/api/v1/forms", params: {form: @form_attributes}, 
            headers: header_with_authentication(@user)
        end

        it "returns Request OK" do
          expect_status(200)
        end

        it "form is created with correct data" do
          @form_attributes.each do |field|
            expect(Form.first[field.first]).to eql(field.last)
          end
        end

        it "Returned data is correct" do
          @form_attributes.each do |field|
            expect(json[field.first.to_s]).to eql(field.last)
          end
        end
      end

      context "with invalid params" do
        before do
          @other_user = create(:user)
          post "/api/v1/forms", params: {form: {}}, 
            headers: header_with_authentication(@user)
        end

        it "returns Bad Request" do
          expect_status(400)
        end
      end
    end
  end

  describe "PUT /forms/:friendly_id" do

    context "With Invalid authentication headers" do
      it_behaves_like :deny_without_authorization, :put, "/api/v1/forms/questionary"
    end

    context "With valid authentication headers" do
      before do
        @user = create(:user)
      end

      context "When form exists" do

        context "user is the owner" do
          before do
            @form = create(:form, user: @user)
            @form_attributes = attributes_for(:form, id: @form.id)
            put "/api/v1/forms/#{@form.friendly_id}", params: {form: @form_attributes}, 
              headers: header_with_authentication(@user)
          end

          it "returns Request OK" do
            expect_status(200)
          end

          it "form is updated with correct data" do
            @form.reload
            @form_attributes.each do |field|
              expect(@form[field.first]).to eql(field.last)
            end
          end

          it "Returned data is correct" do
            @form_attributes.each do |field|
              expect(json[field.first.to_s]).to eql(field.last)
            end
          end
        end

        context "user is not the owner" do
          before do
            @form = create(:form)
            @form_attributes = attributes_for(:form, id: @form.id)
            put "/api/v1/forms/#{@form.friendly_id}", params: {form: @form_attributes}, 
              headers: header_with_authentication(@user)
          end

          it "returns Forbidden" do
            expect_status(403)
          end
        end
      end

      context "When form doesn't exist" do
        before do
          @form_attributes = attributes_for(:form)
        end

        it "returns Not Found" do
          delete "/api/v1/forms/#{FFaker::Lorem.word}", params: {form: @form_attributes}, 
            headers: header_with_authentication(@user)
          expect_status(404)
        end
      end
    end
  end

  describe "DELETE /forms/:friendly_id" do
    before do
      @user = create(:user)
    end

    context "With Invalid authentication headers" do
      it_behaves_like :deny_without_authorization, :delete, "/api/v1/forms/questionary"
    end


    context "With valid authentication headers" do

      context "When form exists" do

        context "user is the owner" do
          before do
            @form = create(:form, user: @user)
            delete "/api/v1/forms/#{@form.friendly_id}", params: {}, 
              headers: header_with_authentication(@user)
          end

          it "returns Request OK" do
            expect_status(200)
          end

          it "form are deleted" do
            expect(Form.all.count).to eql(0)
          end
        end

        context "user is not the owner" do
          before do
            @form = create(:form)
            delete "/api/v1/forms/#{@form.friendly_id}", params: {}, 
              headers: header_with_authentication(@user)
          end

          it "returns Forbidden" do
            expect_status(403)
          end
        end
      end

      context "When form doesn't exist" do
        it "returns Not Found" do
          delete "/api/v1/forms/#{FFaker::Lorem.word}", params: {}, 
            headers: header_with_authentication(@user)
          expect_status(404)
        end
      end

      context "When form exists" do

        context "user is the owner" do
          before do
            @form = create(:form, user: @user)
            delete "/api/v1/forms/#{@form.friendly_id}", params: {}, 
              headers: header_with_authentication(@user)
          end

          it "returns Request OK" do
            expect_status(200)
          end

          it "form is deleted" do
            expect(Form.all.count).to eql(0)
          end
        end

        context "user is not the owner" do
          before do
            @form = create(:form)
            delete "/api/v1/forms/#{@form.friendly_id}", params: {}, 
              headers: header_with_authentication(@user)
          end

          it "returns Forbidden" do
            expect_status(403)
          end
        end
      end

      context "When form doesn't exist" do
        it "returns Not Found" do
          delete "/api/v1/forms/#{FFaker::Lorem.word}", params: {}, 
            headers: header_with_authentication(@user)
          expect_status(404)
        end
      end
    end
  end
end