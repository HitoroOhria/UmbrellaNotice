namespace :line do
  # Messaging API を使用してリッチメニューを作成する
  # 作成しただけでは有効化されないため、
  #   rails line:create_rich_menu_image[<rich_menu_id>]
  # を実行してください
  desc 'Create line rich-menu'
  task create_rich_menu: :environment do
    MENU_WIDTH            = 2500
    MENU_HEIGHT           = 1686
    CONTENT_COUNT         = 6
    WIDTH_SEPARATE_COUNT  = 3
    HEIGHT_SEPARATE_COUNT = 2

    client = Line::Bot::Client.new { |config|
      config.channel_secret = Rails.application.credentials.line_api[:channel_secret_id]
      config.channel_token  = Rails.application.credentials.line_api[:channel_token]
    }

    size    = { width: MENU_WIDTH, height: MENU_HEIGHT }
    actions = %w[reply_weather_forecast notice_time_setting toggle_silent_notice
                 location_resetting issue_serial_number profile_page]

    bounds = proc { |number|
      width_unit  = size[:width] / WIDTH_SEPARATE_COUNT
      height_unit = size[:height] / HEIGHT_SEPARATE_COUNT
      upper_row   = number < WIDTH_SEPARATE_COUNT

      x = upper_row ? width_unit * number : width_unit * (number - 3)
      y = upper_row ? 0 : height_unit

      {
        x: x,
        y: y,
        width:  width_unit - 1,
        height: height_unit - 1
      }
    }

    areas = actions.map.with_index do |action, index|
      area = {
        bounds: bounds.call(index),
        action: {
          type:  'postback',
          data:  action
        }
      }
      case action
      when 'notice_time_setting'
        area[:action][:type]    = 'datetimepicker'
        area[:action][:mode]    = 'time'
        area[:action][:initial] = '07:00'
        area[:action][:max]     = '23:59'
        area[:action][:min]     = '00:00'
      end
      area
    end

    rich_menu = {
      size:        size,
      selected:    false,
      name:        'default rich-menu',
      chatBarText: 'メニュー',
      areas:       areas
    }

    api_response = client.create_rich_menu(rich_menu)
    rich_menu_id = JSON.parse(api_response.body)['richMenuId']

    puts "[Rich_Menu_ID] #{rich_menu_id}"
  end

  desc 'Upload line rich-menu image and Set default rich-mune'
  task :create_rich_menu_image, ['rich_menu_id'] => :environment do |_task, args|
    rich_menu_id = args[:rich_menu_id]
    image_file   = File.open(Rails.root + 'app/assets/images/rich_menu.png')

    client = Line::Bot::Client.new { |config|
      config.channel_secret = Rails.application.credentials.line_api[:channel_secret_id]
      config.channel_token  = Rails.application.credentials.line_api[:channel_token]
    }

    puts "[Upload Image] #{client.create_rich_menu_image(rich_menu_id, image_file)}"
    puts "[Set Default]  #{client.set_default_rich_menu(rich_menu_id)}"
  end

  desc 'Show default line rich-menu'
  task default_rich_menu: :environment do
    client = Line::Bot::Client.new { |config|
      config.channel_secret = Rails.application.credentials.line_api[:channel_secret_id]
      config.channel_token  = Rails.application.credentials.line_api[:channel_token]
    }

    api_response  = client.get_default_rich_menu
    default_id    = JSON.parse(api_response.body)['richMenuId']

    api_response  = client.get_rich_menus
    rich_menus    = JSON.parse(api_response.body)['richmenus']

    rich_menus.each do |rich_menu|
      next unless rich_menu['richMenuId'] == default_id

      puts '[Default Rich_Menu]'
      puts JSON.pretty_generate(rich_menu)
    end
  end

  desc 'Show line rich-menu list'
  task list_rich_menu: :environment do
    client = Line::Bot::Client.new { |config|
      config.channel_secret = Rails.application.credentials.line_api[:channel_secret_id]
      config.channel_token  = Rails.application.credentials.line_api[:channel_token]
    }

    api_response = client.get_rich_menus
    rich_menus   = JSON.parse(api_response.body)['richmenus']

    puts "[合計個数] #{rich_menus.count} 個"
    puts

    rich_menus.each_with_index do |rich_menu, index|
      puts "【No.#{index + 1}】"
      puts JSON.pretty_generate(rich_menu)
      puts
    end
  end

  desc 'Delete line rich-menu'
  task :delete_rich_menu, ['rich_menu_id'] => :environment do |_task, args|
    rich_menu_id = args[:rich_menu_id]

    client = Line::Bot::Client.new { |config|
      config.channel_secret = Rails.application.credentials.line_api[:channel_secret_id]
      config.channel_token  = Rails.application.credentials.line_api[:channel_token]
    }

    puts "[Delete Rich_Menu] #{client.delete_rich_menu(rich_menu_id)}"
  end

  desc 'Delete old line rich-menus'
  task delete_rich_menus: :environment do
    client = Line::Bot::Client.new { |config|
      config.channel_secret = Rails.application.credentials.line_api[:channel_secret_id]
      config.channel_token  = Rails.application.credentials.line_api[:channel_token]
    }

    api_response  = client.get_default_rich_menu
    default_id    = JSON.parse(api_response.body)['richMenuId']

    puts "[Default Rich_Menu_ID] #{default_id}"
    puts

    api_response  = client.get_rich_menus
    rich_menus    = JSON.parse(api_response.body)['richmenus']
    rich_menu_ids = rich_menus.map { |rich_menu| rich_menu['richMenuId'] }

    puts "[削除前の個数] #{rich_menus.count} 個"
    puts '[現在のRich_Menu_IDs]'
    pp   rich_menu_ids
    puts

    rich_menu_ids[0...rich_menu_ids.count].each do |rich_menu_id|
      unless rich_menu_id == default_id
        puts "[Delete Rich_Menu] #{rich_menu_id} #{client.delete_rich_menu(rich_menu_id)}"
      end
    end

    api_response  = client.get_rich_menus
    rich_menus    = JSON.parse(api_response.body)['richmenus']
    rich_menu_ids = rich_menus.map { |rich_menu| rich_menu['richMenuId'] }

    puts
    puts "[削除後の個数] #{rich_menus.count} 個"
    puts '[現在のRich_Menu_IDs]'
    pp   rich_menu_ids
  end
end
