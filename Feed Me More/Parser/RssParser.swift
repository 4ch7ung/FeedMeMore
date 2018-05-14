//
//  RssParser.swift
//  Feed Me More
//
//  Created by macbook on 12.05.2018.
//  Copyright © 2018 4ch7ung. All rights reserved.
//

import Foundation

protocol RssParser {
    func parse(name: String, data: Data) -> [Item]
}

class StandardRssParser: NSObject, RssParser, XMLParserDelegate {
    enum Elem: String {
        case title
        case description
        case pubDate
        case enclosure
        case none
    }
    
    struct State {
        var name: String = ""
        var inItem: Bool = false
        var element: Elem = .none
        
        var curItem: Item = Item()
        var items: [Item] = []
    }
    
    struct ItemNames {
        static let item = "item"
        static let title = "title"
        static let description = "description"
        static let pubDate = "pubDate"
        static let enclosure = "enclosure"
    }
    
    private let supportedImageTypes: [String] = [
        "image/jpeg",
        "image/png"
    ]
    
    private var internalParser: XMLParser?
    private var state: State
    private let dateFormatter: DateFormatter
    
    override init() {
        internalParser = nil
        state = State()
        dateFormatter = RFC822DateFormatter()
    }
    
    func parse(name: String, data: Data) -> [Item] {
        internalParser = XMLParser(data: data)
        self.state = State()
        state.name = name
        
        internalParser?.delegate = self
        internalParser?.parse()
        return state.items
    }
    
    // MARK: - XMLParserDelegate
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        
        switch elementName {
        case ItemNames.item:
            state.inItem = true
            state.curItem = Item()

        case ItemNames.title,
             ItemNames.description,
             ItemNames.pubDate:
            guard state.inItem else { return }
            state.element = Elem(rawValue: elementName)!

        case ItemNames.enclosure:
            guard state.inItem else { return }
            state.element = .enclosure
            if let url = attributeDict["url"],
                let type = attributeDict["type"],
                supportedImageTypes.contains(type) {
                
                state.curItem.imageUrl = url
            }
        default:
            // skip unknown tags
            return
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case ItemNames.item:
            state.inItem = false
            state.curItem.feedName = state.name
            state.items.append(state.curItem)
            
        case ItemNames.description:
            state.curItem.description = state.curItem.description.trimmingCharacters(in: .whitespacesAndNewlines)
            state.element = .none
            
        case ItemNames.title, ItemNames.pubDate, ItemNames.enclosure:
            state.element = .none
            
        default:
            // skip unknown tags
            return
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if state.inItem {
            switch state.element {
            case .title:
                state.curItem.title += string
                
            case .pubDate:
                state.curItem.pubDate = dateFormatter.date(from: string) ?? Date.distantPast
                
            case .description:
                state.curItem.description += string
                
            default:
                // skip unrelated text
                return
            }
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        parser.abortParsing()
        NSLog("\(parseError.localizedDescription)")
    }
}
