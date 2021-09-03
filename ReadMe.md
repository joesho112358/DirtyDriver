# Dirty Driver

What is this thing? It provides an Elixir implementation of [W3C WebDriver endpoints](https://w3c.github.io/webdriver/)

Here is some usage

    DirtyDriver.Browser.open_browser("firefox")
    DirtyDriver.Browser.go_to("http://www.github.com/")
    DirtyDriver.ElementInteraction.element("body", "css selector")
    DirtyDriver.ElementInteraction.text
    DirtyDriver.Browser.end_session
    DirtyDriver.Browser.kill_driver

Look at the tests for more.

### Running tests

`mix test`
`mix test --cover`
`mix test --only run` if test is tagged as `@tag :run`

### Running interactive session

`iex -S mix`
