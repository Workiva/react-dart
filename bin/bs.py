html = """

<html lang="en">
<body>
    <div id="wrap">
        <header>
            <!-- working version it may change -->
            <div class="logo"></div>
            <div class="registration-header">
                <a href="" class="login-btn">
                    prihlásenie
                </a>
                <a href="" class="registration-btn">
                    registrácia
                </a>
            </div>
            <nav>
                <ul>
                    <li><a href="">moja zostava</a></li>
                    <li><a href="">umiestnenie</a></li>
                    <li><a href="">liga</a></li>
                    <li><a href="">odmeny a pravidla</a></li>
                </ul>
            </nav>
        </header>
        <div class="main">
            <h1>Moj profil</h1>
            <div class="profile">
                <div class="narrow-column">
                    <label>Profilova fotografia</label>
                    <img src="images/chuck.jpg" alt="profilova fotka"/>
                </div>
                <div class="wide-column">
                    <div class="profile-row">
                        <label>Pohlavie</label>
                        <span class="help-icon"><span class="help-message">Some message on hover for now. And another text for test.</span></span>
                        <div class="checkbox-group">
                            <input type="radio" name="gender" value="muz" id="gender-male" /><label for="gender-male" tabindex="0"><i></i><span>Muz</span></label>
                            <input type="radio" name="gender" value="zena" id="gender-female" /><label for="gender-female" tabindex="0"><i></i><span>Zena</span></label>
                        </div>
                    </div>
                </div>
                <div class="wide-column">
                    <div class="profile-row">
                        <label for="team-name">Nazov timu</label>
                        <span class="help-icon"><span class="help-message">Some message on hover for now. And another text for test.</span></span>
                        
                        <input type="text" value="Nazov timu" name="team-name" id="team-name"/>
                    </div>
                    <div class="profile-row">
                        <label for="psc">PSC</label>
                        <span class="help-icon"><span class="help-message">Some message on hover for now. And another text for test.</span></span>
                        
                        <input type="text" value="PSC" name="psc" id="psc" class="small-input"/>
                    </div>
                    <div class="profile-row">
                        <div>
                            <label>Zasielanie informacii emailom</label>
                            <span class="help-icon"><span class="help-message">Some message on hover for now. And another text for test.</span></span>
                        </div>
                        <div class="input-style-line">
                            <input type="checkbox" name="newsletter" value="agree" id="newsletter"/><label for="newsletter"><i></i><span>Posielat informacie lorem ipsum</span></label>
                        </div>
                    </div>
                </div>
                <div class="full">
                    <div class="wide-column right">
                        <button class="save-changes-btn">Ulozit zmeny</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <footer>
        <div class="center-block">
            &copy; 2.13 nazov spolocnosti, all rights reserved
        </div>
    </footer>
</body>
</html>
"""

html1="""
    <div class='container' onclick="{handler}" >
    <!-- zis is chinglish comet -->
        <MyTag> mytag </MyTag>
        <MyTag name = "{jozo}" /> 
        <div id='class'>
           <span> Something here </span>
        </div>
        <div>Something else</div>
    </div>
"""

import sys
if len(sys.argv)>=2:
    filename=sys.argv[1]
    html=open(filename,'r').read()

from bs4 import BeautifulSoup as BS
from bs4 import NavigableString, Comment

def _val(val):
    if isinstance(val, list):
        val = val[0]
    if len(val)>2 and val[0]=='{' and val[-1]=='}':
        return val[1:-1]
    else:
        return "'"+val+"'"

def _key(key):
    if key=='class':
        return "'className'"
    if key=='for':
        return "'htmlFor'"
    else:
        return "'"+key+"'"


def make_comment(node):
    res = ' // ' + node.name
    if 'class' in node.attrs:
        cl = node.attrs['class']
        if isinstance(cl, list):
            cl = cl[0]
        res+='(%s)'%cl
    return res

def to_react(node, indent = 0, trailing_comma = False):
    indent_str = " "*2*indent
    if isinstance(node,Comment):
        return None
    if isinstance(node,NavigableString):
        if len(str(node).strip(' \n\t'))==0:
             return None
        else:
             return indent_str+'"%s"'%str(node).strip(' \n\t')
    props = ', '.join("%s: %s"%(_key(key), _val(val)) for key, val in node.attrs.items())
    if len(list(node.children)) > 1:
        children = '\n'.join(to_react(child, indent+1, trailing_comma = True) for child in node.children if to_react(child))
        children = '[\n%s\n%s]' % (children, indent_str)
        comment = make_comment(node)
    elif len(list(node.children)) == 1:
        children = to_react(node.children.__next__(),0)
        comment=''
    else:
        children= '[]'
        comment=''
    if trailing_comma:
        comma=', '
    else:
        comma=''
    return '%s%s({%s}, %s)%s%s'%(indent_str,node.name,props,children,comma,comment)


soup = BS(html, 'xml')

#simple magic to find reasonable root element
for parent in soup.find_all():
    if parent.name!='html' and parent.name!='body' and parent.name!='head':
        break
print(to_react(parent))


