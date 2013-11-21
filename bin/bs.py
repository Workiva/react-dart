html="""
<body pokus='true'>
    <div class='container', onclick={handler} >
        <div id='class'>Something here</div>
        <div>Something else</div>
    </div>
</body>
"""

from bs4 import BeautifulSoup as BS
from bs4 import NavigableString

def _val(val):
    if isinstance(val, list):
        val = val[0]
    if val[0]=='{' and val[-1]=='}':
        return val[1:-1]
    else:
        return "'"+val+"'"

def _key(key):
    if key=='class':
        return 'className'
    else:
        return "'"+key+"'"


def to_react(node, indent=0):
    indent_str = " "*4*indent
    if isinstance(node,NavigableString):
        if len(str(node).strip(' \n\t'))==0:
             return None
        else:
             return indent_str+'''"%s"'''%str(node).strip(' \n\t')
    props = ', '.join("%s: %s"%(_key(key), _val(val)) for key, val in node.attrs.items())
    children = ',\n'.join(to_react(child, indent+1) for child in node.children if to_react(child))
    return '%s%s({%s}, [\n%s\n%s])'%(indent_str,node.name,props,children,indent_str)


soup = BS(html)

parent = soup.body
print(to_react(parent))


