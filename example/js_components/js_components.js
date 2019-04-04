const {createMuiTheme, colors} = window['material-ui'];

const theme = createMuiTheme({
  palette: {
    primary: {
      light: colors.purple[300],
      main: colors.purple[500],
      dark: colors.purple[700],
    },
    secondary: {
      light: colors.green[300],
      main: colors.green[500],
      dark: colors.green[700],
    },
  },
  typography: {
    useNextVariants: true,
  },
});

class _SimpleCustomComponent extends React.Component {
  render() {
    return (
      [
        'This is some content to show that custom JS components also work!',
      ]
    );
  }

  getFoo() {
    return this.props.foo;
  }
}
