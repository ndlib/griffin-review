module RequestMacros

      def login_user
        before(:each) do
          @request.env["devise.mapping"] = Devise.mappings[:user]
          @user = FactoryBot.create(:user)
          sign_in @user
        end

        after(:each) do
          @user.destroy
        end
      end

      def login_admin

        before(:each) do
          @request.env["devise.mapping"] = Devise.mappings[:user]
          @admin_role = FactoryBot.create(:admin_role)
          @admin_user = FactoryBot.create(:user, :roles => [@admin_role])
          sign_in @admin_user
        end

        after(:each) do
          @admin_user.destroy
          @admin_role.destroy
        end

      end

end
