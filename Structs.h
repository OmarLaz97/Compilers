typedef enum {Const_Type, Identifier_Type, Opr_Type} NodeEnum;
typedef enum {isInteger, isFloat, isChar, isString} TypeEnum;
typedef enum {NotDeclared, isConst, Declared} PermissionEnum;

/* Node for Constants */
typedef struct {
    TypeEnum ConstType;
    char *Value;
} ConstNode;

/* Node for Identifiers */
typedef struct {
    int SymIndex;
    TypeEnum IdentiType;
    PermissionEnum IdentPermission;
    char *IdentName;
} IdentifierNode;

/* Node for Operators */
typedef struct {
    int oper;                   /* operator */
    int nops;                   /* number of operands */
    struct nodeTypeTag *op[1];	/* operands, extended at runtime */
} OperNode;

typedef struct nodeTypeTag {
    NodeEnum type;              /* type of node */

    union {
        ConstNode con;        /* constants */
        IdentifierNode id;          /* identifiers */
        OperNode opr;        /* operators */
    };
} nodeType;

