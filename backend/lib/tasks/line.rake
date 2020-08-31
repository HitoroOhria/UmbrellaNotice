namespace :line do
  namespace :message do
    # @param number_of_executions [Number] count of iteration read_message.
    # write for weather_trivia.txt.erb.
    desc 'Preview line message'
    task :preview, %w[line_message_file number_of_executions] => :environment do |_task, args|
      line_message_file    = args[:line_message_file]
      number_of_executions = args[:number_of_executions]

      if number_of_executions
        messages = (0..number_of_executions.to_i).to_a.flat_map do
          LineMessageCreator.create_from(line_message_file)
        end

        messages.each { |message| puts message[:text] }
      else
        puts LineMessageCreator.create_from(line_message_file)[:text]
      end
    end
  end

  namespace :rich_menu do
    # make Rich Menu used LINE Messaging API.
    # Run next command because not available just made.
    #   rails line:create_rich_menu_image[<rich_menu_id>]
    # see https://developers.line.biz/ja/reference/messaging-api/#create-rich-menu
    desc 'Create line rich-menu'
    task create: :environment do
      MENU_WIDTH            = 1200
      MENU_HEIGHT           = 820
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
        width_unit  = MENU_WIDTH / WIDTH_SEPARATE_COUNT
        height_unit = MENU_HEIGHT / HEIGHT_SEPARATE_COUNT
        upper_tier  = number < 3

        x = upper_tier ? width_unit * number : width_unit * (number - 3)
        y = upper_tier ? 0 : height_unit

        width  = width_unit
        height = height_unit

        {
          x: x,
          y: y,
          width:  width,
          height: height
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

      puts "[Create Rich_Menu] #{api_response}"
      puts "[Rich_Menu_ID]     #{rich_menu_id}"
    end

    # rails line:create_rich_menu_image[<rich_menu_id>]
    # @param image_file = 'app/assets/images/rich_menu.png'
    desc 'Upload line rich-menu image and Set default rich-menu'
    task :create_image, ['rich_menu_id'] => :environment do |_task, args|
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
    task default: :environment do
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
    task list: :environment do
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
    task :delete, ['rich_menu_id'] => :environment do |_task, args|
      rich_menu_id = args[:rich_menu_id]

      client = Line::Bot::Client.new { |config|
        config.channel_secret = Rails.application.credentials.line_api[:channel_secret_id]
        config.channel_token  = Rails.application.credentials.line_api[:channel_token]
      }

      puts "[Delete Rich_Menu] #{client.delete_rich_menu(rich_menu_id)}"
    end

    desc 'Delete old line rich-menus'
    task delete_menus: :environment do
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
end
