Deface::Override.new(
  virtual_path:  'spree/layouts/admin',
  name:          'vendors_main_menu_tabs',
  insert_bottom: '#main-sidebar',
  text:       <<-HTML
                <% if current_spree_user.respond_to?(:has_spree_role?) && current_spree_user.has_spree_role?(:admin) %>
                  <ul class="nav nav-sidebar">
                    <%= tab "My Stores", url: admin_vendors_path, icon: 'money' %>
                  </ul>
                <% end %>
                <% if current_spree_vendor %>
                  <ul class="nav nav-sidebar">
                    <%= tab "My Profile", url: admin_vendor_settings_path, icon: 'money' %>
                  </ul>
                <% end %>
              HTML
)
