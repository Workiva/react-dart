html="""
<body pokus='true'>
    <div class='container'>
        <div id='class'>Something here</div>
        <div>Something else</div>
    </div>
</body>
"""

from bs4 import BeautifulSoup as BS
from bs4 import NavigableString


def to_react(node, indent=0):
    indent_str = " "*4*indent
    if isinstance(node,NavigableString):
        if len(str(node).strip(' \n\t'))==0:
             return None
        else:
             return indent_str+'''"%s"'''%str(node).strip(' \n\t')
    props = ','.join("%s: %s"%(str(key), str(val[0])) for key, val in node.attrs.items())
    children = ',\n'.join(to_react(child, indent+1) for child in node.children if to_react(child))
    return '%s%s({%s}, [\n%s\n%s])'%(indent_str,node.name,props,children,indent_str)


soup = BS(html)

parent = soup.body
print(to_react(parent))


