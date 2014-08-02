Rails.application.assets.register_engine '.md', AssetTemplate::SimpleMarkdownTemplate
Rails.application.assets.register_engine '.mkd', AssetTemplate::SimpleMarkdownTemplate
Rails.application.assets.register_engine '.markdown', AssetTemplate::SimpleMarkdownTemplate
Rails.application.assets.register_engine '.post', AssetTemplate::PostTemplate
