# Dirty Driver

What is this thing? It provides an Elixir implementation of [W3C WebDriver endpoints](https://w3c.github.io/webdriver/)

Here is some usage

    DirtyDriver.Browser.open_browser("firefox")
    DirtyDriver.Browser.go_to("http://www.github.com/")
    DirtyDriver.ElementInteraction.element("body", "css selector")
    DirtyDriver.ElementInteraction.text()
    DirtyDriver.Browser.end_session()
    DirtyDriver.Browser.kill_driver()

### Running tests

`mix test`

### Running interactive session

`iex -S mix`
