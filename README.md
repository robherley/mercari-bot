> [!WARNING]  
> This repository has been long outdated since Mercari has updated their frontend and the scraping code no longer works.
> Instead, checkout [robherley/sendibot](https://github.com/robherley/sendibot) that support Mercari, Yahoo Auctions/Shopping and more!

# mercari-bot

Scrape [Mercari (JPN)](https://www.mercari.jp/) listing for specific keywords or
categories and get notified on Discord. Seen items are cached between runs
within a SQLite DB to avoid dupe messages.

## TODO

- [ ] Remaining DB logic
- [ ] Discord integration
- [ ] Add actions workflow cron (upload SQLite file as artifact???)
- [ ] Finish this readme

## Running locally
1. `bundle install`
2. `bin/bot [options]` or `bin/bot --help` for params

    Example:
    ```console
    $ # Search for keywords "gameboy" and "psp", plus include anything in category 703
    $ bin/bot --token $TOKEN -k gameboy,psp -c 703
    ```
3. (optional) `bin/console` to debug

## Some FYIs
- Categories are magic numbers that can be found in the site's URL. ie, `703` from `https://www.mercari.com/jp/category/703/` is for "handheld game consoles"
- Only pulls first page of items (for both search results and categories)
- DB Cache removes items that have not been seen on first page for > 1 day
- Links go to [Sendico](https://www.sendico.com/)
- Description is in Japanese
- Sold items are skipped

## Item Structure

```ruby
{
  id: 271,
  mercari_id: "m53624758387",
  href: "/jp/items/m53624758387/",
  sendico_url: "https://www.sendico.com/mercari/item/m53624758387",
  img: "https://static.mercdn.net/c!/w=240/thumb/photos/m53624758387_1.jpg?1548550425",
  price_usd: "$66.43",
  price_jpy: "¥7,300",
  description: "PSP Go 本体 ホワイト6",
  sold: true,
  created_at: '2021-09-18 05:58:19.041139 UTC',
  updated_at: '2021-09-18 05:58:19.041139 UTC'
}
```
