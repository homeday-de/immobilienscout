# ImmobilienScout gem

This is an interface for ImmobilienScout API

## Example
Set up your keys in `immoscout.rb` inside initializers.
```ruby
Immoscout.configure do |config|
  config.consumer_key = 'consumer_key'
  config.consumer_secret = 'consumer_secret'
  config.access_token = 'access_token'
  config.access_token_secret = 'acceess_token_secret'
  config.use_sandbox = true
end

```

## Methods

#### Property
 - Create Property
```ruby
Immobilienscout::API::Property.create({params})
```

- Publish Property
```ruby
Immobilienscout::API::Property.publish({params})
```

- Delete Property
```ruby
Immobilienscout::API::Property.destroy(is24_id)
```

#### Attachment
 - Add attachments to property
```ruby
Immobilienscout::API::Attachment.add(is24_id, binary_file, {metadata})
```

#### Report
- Get Scout Report
```ruby
Immobilienscout::API::Report.retrieve(is24_id, date_from, date_to)
```

#### IMPORTANT: Check Immobilienscout Documentation about the needed params.


## ImmobilienScout API

 https://api.immobilienscout24.de/our-apis/import-export.html
