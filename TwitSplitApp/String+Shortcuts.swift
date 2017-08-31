//
//  String+Shortcuts.swift
//  TwitSplitApp
//
//  Created by khoa on 8/30/17.
//  Copyright © 2017 Mai Cong Uan. All rights reserved.
//

import Foundation

extension String {
    func length() -> Int {
        return Int(self.characters.count)
    }

    static func splitMessage(message: String, omittingEmptySubsequences: Bool = true) -> [String]? {
        if(message.length() <= Contants.maxMessageLength) {
            return [message]
        }
        
        // split message into word.
        let words = message.characters.split(separator: " ", maxSplits:Int.max, omittingEmptySubsequences: omittingEmptySubsequences).map(String.init)
        
        if(words.count < 0) {
            return nil
        }
        else if(words.count == 1) {
            if(words[0].length() > Contants.maxMessageLength) {
                return nil
            }
            return words
        }
        
        // split message
        var isSuccessful = true
        var chunks = [String]()
        let maxTotalLength = words.count.length() + 1
        
        for totalLength in 1..<(maxTotalLength + 1) {
            isSuccessful = true
            
            chunks.removeAll()
            
            let lastPartIndicatorLength = totalLength + 2 // 1 space for character "/" and 1 space for blank
            
            // try split message with assuming that total line is numLine
            var tempStr = words[0]
            var currentLine = 1
            
            for i in 1..<(words.count)  {
                
                if currentLine.length() > totalLength {
                    //  set flag fail and break
                    isSuccessful = false
                    break
                }
                
                let word = words[i]
                
                if(word.length() >= Contants.maxMessageLength) {
                    return nil
                }
                
                let indicatorLength =  currentLine.length() + lastPartIndicatorLength
                
                if(tempStr.length() + word.length() + indicatorLength < Contants.maxMessageLength) {
                    tempStr += (" " + word)
                }
                else {
                    if tempStr.length() > Contants.maxMessageLength - indicatorLength {
                        // set flag fail and break here
                        isSuccessful = false
                        
                        break
                    }
                    
                    
                    chunks.append(tempStr)
                    
                    tempStr = word
                    
                    currentLine = chunks.count + 1
                }
            }
            
            if(tempStr.length() > 0) {
                if tempStr.length() > Contants.maxMessageLength - currentLine.length() - lastPartIndicatorLength {
                    // set flag fail and break here
                    isSuccessful = false
                }
                else {
                    chunks.append(tempStr)
                }
                
            }
            
            
            //
            if(isSuccessful) {
                break
            }
        }
        
        if !isSuccessful || chunks.isEmpty {
            return nil
        }
        
        // adding indicator 
        for i in 0..<(chunks.count) {
            chunks[i] = chunks[i].appendingIndicator(current: i + 1, total: chunks.count)
        }
        
        return chunks
    }
    
    func appendingIndicator(current:Int, total: Int) -> String {
        return String(current) + "/" + String(total) + " " + self
    }
}
