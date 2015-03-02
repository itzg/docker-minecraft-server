# -*- coding: utf-8 -*-
import scrapy
from scrapy.contrib.spiders import CrawlSpider, Rule
from scrapy.contrib.linkextractors import LinkExtractor
from scrapy.selector import Selector

import re

class Forge(scrapy.Item):
    versions = scrapy.Field()
    latest = scrapy.Field()

class ForgeVersions(scrapy.Item):
    id = scrapy.Field()
    minecraft = scrapy.Field()
    type = scrapy.Field()
    time = scrapy.Field()
    url = scrapy.Field()

class ForgeLatest(scrapy.Item):
    forge_latest = scrapy.Field()
    forge_recommended = scrapy.Field()

class ForgeSpider(CrawlSpider):
    name = "ForgeSpider"
    allowed_domains = ["minecraftforge.net"]
    start_urls = ['http://files.minecraftforge.net']

    def parse(self, response):
        forge = Forge()
        forge['versions'] = []
        forge['latest'] = ForgeLatest()

        selector = Selector(response)
        rows = selector.xpath('//table[@id="promotions_table"]//tr')
        header = rows.pop(0)
        for row in rows:
            cells = row.xpath('td')

            id = cells[1].xpath('text()').extract()
            minecraft = cells[2].xpath('text()').extract()
            type = cells[0].xpath('text()')
            time = cells[3].xpath('text()')
            url = cells[4].xpath('a[text()="Installer"]/@href')

            #if has version
            has_version = re.match('(.+)\-.+', ''.join(type.extract()))
            if has_version:
                download = ForgeVersions()
                download['id'] = id
                download['minecraft'] = minecraft
                download['type'] = 'forge_' + ''.join(type.re('([a-zA-Z]+)')).lower()
                download['time'] = time.extract()
                download['url'] = url.re('http://adf.ly/\d+/(.+)')
                
                forge['versions'].append(download)
            else:
                is_recommended = re.match('Recommended', ''.join(type.extract()))
                if is_recommended:
                    download = ForgeLatest()
                    forge['latest']['forge_recommended'] = id
                else:
                    download = ForgeLatest()
                    forge['latest']['forge_latest'] = id


        return forge

