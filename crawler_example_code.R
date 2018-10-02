# bring packages into the workspace
library(RCurl)  # functions for gathering data from the web
library(XML)  # XML and HTML parsing

# gather home page for ToutBay using RCurl package
url = 'http://blog.sleepinginairports.net'

getLinks <- function(x,npar=TRUE,print=TRUE) {
  web_page_text <- getURLContent(x)
  web_page_tree <- htmlTreeParse(web_page_text, useInternalNodes = TRUE,
                                 asText = TRUE, isHTML = TRUE)
  web_page_content <- xpathSApply(web_page_tree, "//a[@href]", xmlGetAttr, 'href')
  return(web_page_content[1:30])
}

web_page_content <- getLinks(url)
internal <- vector()
external <- vector()
for (weburl in web_page_content){
  if (grepl("sleepinginairports.net", weburl)){
    internal <- c(internal, weburl)
    secondwpc <- getLinks(weburl)
    for (secdonweburl in secondwpc){
      if (grepl("sleepinginairports.net", secdonweburl)){
        internal <- c(internal, secdonweburl)
      }else{
        external <- c(external, secdonweburl)
      }
    }
  }else{
    external <- c(external, weburl)
  }
}

print(external)

# send content to external text file for review
sink("text_file_for_review.txt")
print(web_page_content)
sink()
