PGDMP     )                
    z         
   GameBridge    13.3    13.3 }    v           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            w           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            x           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            y           1262    165761 
   GameBridge    DATABASE     n   CREATE DATABASE "GameBridge" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Spanish_El Salvador.1252';
    DROP DATABASE "GameBridge";
                postgres    false            ?            1255    165762    diasclave(date)    FUNCTION     ?   CREATE FUNCTION public.diasclave(fecha date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    dias int;
BEGIN
    SELECT(fecha - (SELECT CURRENT_DATE)) INTO dias;
    RETURN dias;
END
$$;
 ,   DROP FUNCTION public.diasclave(fecha date);
       public          postgres    false            ?            1255    165763    diasclave2(date)    FUNCTION     ?   CREATE FUNCTION public.diasclave2(fecha date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    dias int;
BEGIN
    SELECT(fecha - (SELECT CURRENT_DATE)) INTO dias;
    RETURN dias;
END
$$;
 -   DROP FUNCTION public.diasclave2(fecha date);
       public          postgres    false            ?            1255    165764 =   funcionbusquedaproducto(character varying, character varying)    FUNCTION     &  CREATE FUNCTION public.funcionbusquedaproducto(character varying, character varying, OUT out_idproducto integer, OUT out_categoria character varying, OUT out_estado character varying, OUT out_marca character varying, OUT out_producto character varying, OUT out_precio numeric, OUT out_descripcion character varying, OUT out_cantidad integer, OUT out_imagen bytea) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $_$
DECLARE
    reg RECORD;
BEGIN   
	FOR REG IN SELECT IdProducto,Categorias.Categoria, EstadoProductos.Estado, Marcas.Marca, Productos.Producto,
	Productos.Precio,Descripcion,Cantidad,Imagen
	from Productos 
	INNER JOIN Categorias on Productos.Categoria=Categorias.idCategoria
	INNER JOIN EstadoProductos on Productos.Estado=EstadoProductos.idEstado 
	INNER JOIN Marcas on Marcas.idMarca = Productos.marca 
	WHERE Productos.Producto LIKE '%'  || $1 || '%' AND EstadoProductos.Estado = 'Disponible' 
	AND Categorias.Categoria = $2
	LOOP
		out_IdProducto := reg.IdProducto;
        out_categoria := reg.categoria;
        out_estado := reg.estado;
        out_marca  := reg.marca;
        out_producto := reg.producto;
        out_precio   := reg.precio;
		out_descripcion := reg.descripcion;
		out_cantidad := reg.cantidad;
		out_imagen := reg.imagen;
       RETURN NEXT;
    END LOOP;
	RETURN;
END $_$;
 k  DROP FUNCTION public.funcionbusquedaproducto(character varying, character varying, OUT out_idproducto integer, OUT out_categoria character varying, OUT out_estado character varying, OUT out_marca character varying, OUT out_producto character varying, OUT out_precio numeric, OUT out_descripcion character varying, OUT out_cantidad integer, OUT out_imagen bytea);
       public          postgres    false            ?            1255    165765 (   funcioncargarcatalogo(character varying)    FUNCTION        CREATE FUNCTION public.funcioncargarcatalogo(character varying, OUT out_idproducto integer, OUT out_categoria character varying, OUT out_estado character varying, OUT out_marca character varying, OUT out_producto character varying, OUT out_precio numeric, OUT out_descripcion character varying, OUT out_cantidad integer, OUT out_imagen bytea) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $_$
DECLARE
    reg RECORD;
BEGIN   
	FOR REG IN SELECT IdProducto,Categorias.Categoria, EstadoProductos.Estado, Marcas.Marca, Productos.Producto,
	Productos.Precio,Descripcion,Cantidad,Imagen
	from Productos 
	INNER JOIN Categorias on Productos.Categoria=Categorias.idCategoria
	INNER JOIN EstadoProductos on Productos.Estado=EstadoProductos.idEstado 
	INNER JOIN Marcas on Marcas.idMarca = Productos.marca 
	WHERE Categorias.Categoria = $1 AND EstadoProductos.Estado = 'Disponible'
	ORDER BY Productos.Precio ASC
	LOOP
		out_IdProducto := reg.IdProducto;
        out_categoria := reg.categoria;
        out_estado := reg.estado;
        out_marca  := reg.marca;
        out_producto := reg.producto;
        out_precio   := reg.precio;
		out_descripcion := reg.descripcion;
		out_cantidad := reg.cantidad;
		out_imagen := reg.imagen;
       RETURN NEXT;
    END LOOP;
	RETURN;
END $_$;
 V  DROP FUNCTION public.funcioncargarcatalogo(character varying, OUT out_idproducto integer, OUT out_categoria character varying, OUT out_estado character varying, OUT out_marca character varying, OUT out_producto character varying, OUT out_precio numeric, OUT out_descripcion character varying, OUT out_cantidad integer, OUT out_imagen bytea);
       public          postgres    false            ?            1255    165766    generarcodigo()    FUNCTION     ?   CREATE FUNCTION public.generarcodigo() RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare retorno int := (SELECT trunc(random() * 999999 + 100000) FROM generate_series(1,1)); 
	begin		
		return retorno;
	end
$$;
 &   DROP FUNCTION public.generarcodigo();
       public          postgres    false            ?            1255    165767    otras(date)    FUNCTION     ?   CREATE FUNCTION public.otras(fecha_vcto date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    diasfecha3 int;
BEGIN

    Select(select current_date-fecha_vcto) into diasfecha3;
    return diasfecha3;
END
$$;
 -   DROP FUNCTION public.otras(fecha_vcto date);
       public          postgres    false            ?            1255    165768 /   procedimientodetalle(integer, integer, integer)    FUNCTION     }  CREATE FUNCTION public.procedimientodetalle(varcliente integer, varproducto integer, varcantidad integer) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$  
declare varprecioUnitario real := (SELECT (precio) FROM Productos WHERE idProducto = varProducto);
declare varSubtotal real := (varprecioUnitario * varCantidad);
declare varidPedido int := (SELECT (idPedido) FROM Pedidos where cliente = varCliente); 
declare totalPedido numeric; 
	begin		
		IF varidPedido is null THEN
		 	insert into Pedidos values (default,varCliente,1,3,1,default);
			varidPedido = (SELECT MAX(idPedido) from Pedidos);
		END IF;
		insert into detallePedidos values (default,varidPedido,varProducto,varprecioUnitario,varCantidad,varSubtotal);
		totalPedido := (select sum(subtotal) from detallePedidos where pedido = varidPedido); 
		update Pedidos set total = totalPedido where idpedido = varidPedido;
	end
$$;
 i   DROP FUNCTION public.procedimientodetalle(varcliente integer, varproducto integer, varcantidad integer);
       public          postgres    false            ?            1259    165769 	   foo_a_seq    SEQUENCE     s   CREATE SEQUENCE public.foo_a_seq
    START WITH 14
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
     DROP SEQUENCE public.foo_a_seq;
       public          postgres    false            ?            1259    165771 
   categorias    TABLE     ?   CREATE TABLE public.categorias (
    idcategoria integer DEFAULT nextval('public.foo_a_seq'::regclass) NOT NULL,
    seccion integer NOT NULL,
    categoria character varying(30)
);
    DROP TABLE public.categorias;
       public         heap    postgres    false    200            ?            1259    165775    clientes    TABLE     ?  CREATE TABLE public.clientes (
    idcliente integer NOT NULL,
    estado integer NOT NULL,
    nombres character varying(40) NOT NULL,
    apellidos character varying(40) NOT NULL,
    dui character(10) NOT NULL,
    correo_electronico character varying(50) NOT NULL,
    clave character varying(200) NOT NULL,
    fecharegistro timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    codigo_recu integer,
    fechaclave date DEFAULT CURRENT_DATE,
    intentos integer DEFAULT 0
);
    DROP TABLE public.clientes;
       public         heap    postgres    false            ?            1259    165781    clientes_idcliente_seq    SEQUENCE     ?   CREATE SEQUENCE public.clientes_idcliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.clientes_idcliente_seq;
       public          postgres    false    202            z           0    0    clientes_idcliente_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.clientes_idcliente_seq OWNED BY public.clientes.idcliente;
          public          postgres    false    203            ?            1259    165783    detallepedidos    TABLE     ?   CREATE TABLE public.detallepedidos (
    iddetallefactura integer NOT NULL,
    pedido integer NOT NULL,
    producto integer NOT NULL,
    preciounitario numeric(7,2) DEFAULT 0.0 NOT NULL,
    cantidad integer DEFAULT 0 NOT NULL
);
 "   DROP TABLE public.detallepedidos;
       public         heap    postgres    false            ?            1259    165788 #   detallepedidos_iddetallefactura_seq    SEQUENCE     ?   CREATE SEQUENCE public.detallepedidos_iddetallefactura_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 :   DROP SEQUENCE public.detallepedidos_iddetallefactura_seq;
       public          postgres    false    204            {           0    0 #   detallepedidos_iddetallefactura_seq    SEQUENCE OWNED BY     k   ALTER SEQUENCE public.detallepedidos_iddetallefactura_seq OWNED BY public.detallepedidos.iddetallefactura;
          public          postgres    false    205            ?            1259    165790    direcciones    TABLE     ?   CREATE TABLE public.direcciones (
    iddireccion integer NOT NULL,
    cliente integer NOT NULL,
    direccion character varying(150) NOT NULL,
    codigo_postal character(4) NOT NULL,
    telefono_fijo character(9)
);
    DROP TABLE public.direcciones;
       public         heap    postgres    false            ?            1259    165793    direcciones_iddireccion_seq    SEQUENCE     ?   CREATE SEQUENCE public.direcciones_iddireccion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.direcciones_iddireccion_seq;
       public          postgres    false    206            |           0    0    direcciones_iddireccion_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.direcciones_iddireccion_seq OWNED BY public.direcciones.iddireccion;
          public          postgres    false    207            ?            1259    165795    estadocliente    TABLE     g   CREATE TABLE public.estadocliente (
    idestado integer NOT NULL,
    estado character varying(20)
);
 !   DROP TABLE public.estadocliente;
       public         heap    postgres    false            ?            1259    165798    estadofactura    TABLE     w   CREATE TABLE public.estadofactura (
    idestado integer NOT NULL,
    estadofactura character varying(25) NOT NULL
);
 !   DROP TABLE public.estadofactura;
       public         heap    postgres    false            ?            1259    165801    estadoproductos    TABLE     r   CREATE TABLE public.estadoproductos (
    idestado integer NOT NULL,
    estado character varying(15) NOT NULL
);
 #   DROP TABLE public.estadoproductos;
       public         heap    postgres    false            ?            1259    165804    estadousuarios    TABLE     q   CREATE TABLE public.estadousuarios (
    idestado integer NOT NULL,
    estado character varying(20) NOT NULL
);
 "   DROP TABLE public.estadousuarios;
       public         heap    postgres    false            ?            1259    165807    facturas    TABLE     ?   CREATE TABLE public.facturas (
    idfactura integer NOT NULL,
    cliente integer NOT NULL,
    vendedor integer,
    estado integer NOT NULL,
    entrega integer
);
    DROP TABLE public.facturas;
       public         heap    postgres    false            ?            1259    165810    historialcliente    TABLE     ?   CREATE TABLE public.historialcliente (
    idregistro integer NOT NULL,
    cliente integer NOT NULL,
    sistema character varying(100),
    hora timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
 $   DROP TABLE public.historialcliente;
       public         heap    postgres    false            ?            1259    165814    historialcliente_idregistro_seq    SEQUENCE     ?   CREATE SEQUENCE public.historialcliente_idregistro_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.historialcliente_idregistro_seq;
       public          postgres    false    213            }           0    0    historialcliente_idregistro_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.historialcliente_idregistro_seq OWNED BY public.historialcliente.idregistro;
          public          postgres    false    214            ?            1259    165816    historialusuario    TABLE     ?   CREATE TABLE public.historialusuario (
    idregistro integer NOT NULL,
    usuario integer NOT NULL,
    sistema character varying(100) NOT NULL,
    hora timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
 $   DROP TABLE public.historialusuario;
       public         heap    postgres    false            ?            1259    165820    historialusuario_idregistro_seq    SEQUENCE     ?   CREATE SEQUENCE public.historialusuario_idregistro_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.historialusuario_idregistro_seq;
       public          postgres    false    215            ~           0    0    historialusuario_idregistro_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.historialusuario_idregistro_seq OWNED BY public.historialusuario.idregistro;
          public          postgres    false    216            ?            1259    165822    marcas    TABLE     ^   CREATE TABLE public.marcas (
    idmarca integer NOT NULL,
    marca character varying(40)
);
    DROP TABLE public.marcas;
       public         heap    postgres    false            ?            1259    165825    pedidos_idpedido_seq    SEQUENCE     ?   CREATE SEQUENCE public.pedidos_idpedido_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.pedidos_idpedido_seq;
       public          postgres    false    212                       0    0    pedidos_idpedido_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.pedidos_idpedido_seq OWNED BY public.facturas.idfactura;
          public          postgres    false    218            ?            1259    165827 	   productos    TABLE     ?  CREATE TABLE public.productos (
    idproducto integer NOT NULL,
    categoria integer NOT NULL,
    estado integer NOT NULL,
    marca integer NOT NULL,
    producto character varying(75) NOT NULL,
    precio numeric(7,2) DEFAULT 0.1 NOT NULL,
    descripcion character varying(200) NOT NULL,
    imagen character varying(100) DEFAULT 'disco-duro-seagete-1tb.png'::character varying,
    cantidad integer DEFAULT 0
);
    DROP TABLE public.productos;
       public         heap    postgres    false            ?            1259    165833    productos_idproducto_seq    SEQUENCE     ?   CREATE SEQUENCE public.productos_idproducto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.productos_idproducto_seq;
       public          postgres    false    219            ?           0    0    productos_idproducto_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.productos_idproducto_seq OWNED BY public.productos.idproducto;
          public          postgres    false    220            ?            1259    165835 	   secciones    TABLE     e   CREATE TABLE public.secciones (
    idseccion integer NOT NULL,
    seccion character varying(30)
);
    DROP TABLE public.secciones;
       public         heap    postgres    false            ?            1259    165838    tipousuarios    TABLE     r   CREATE TABLE public.tipousuarios (
    idtipo integer NOT NULL,
    tipousuario character varying(25) NOT NULL
);
     DROP TABLE public.tipousuarios;
       public         heap    postgres    false            ?            1259    165841    usuarios    TABLE     ?  CREATE TABLE public.usuarios (
    idusuario integer NOT NULL,
    tipo integer NOT NULL,
    estado integer NOT NULL,
    usuario character varying(35) NOT NULL,
    clave character varying(60) DEFAULT 'primeruso'::character varying NOT NULL,
    correo_electronico character varying(60) NOT NULL,
    fecharegistro timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fechaclave date DEFAULT CURRENT_DATE NOT NULL,
    intentos integer,
    codigo_recu integer
);
    DROP TABLE public.usuarios;
       public         heap    postgres    false            ?            1259    165847    usuarios_idusuario_seq    SEQUENCE     ?   CREATE SEQUENCE public.usuarios_idusuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.usuarios_idusuario_seq;
       public          postgres    false    223            ?           0    0    usuarios_idusuario_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.usuarios_idusuario_seq OWNED BY public.usuarios.idusuario;
          public          postgres    false    224            ?            1259    165849    valoraciones    TABLE     (  CREATE TABLE public.valoraciones (
    id_valoracion integer NOT NULL,
    id_detalle integer NOT NULL,
    calificacion_producto integer,
    comentario_producto character varying(250),
    fecha_comentario timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    estado_comentario boolean
);
     DROP TABLE public.valoraciones;
       public         heap    postgres    false            ?            1259    165853    valoraciones_id_valoracion_seq    SEQUENCE     ?   CREATE SEQUENCE public.valoraciones_id_valoracion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.valoraciones_id_valoracion_seq;
       public          postgres    false    225            ?           0    0    valoraciones_id_valoracion_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.valoraciones_id_valoracion_seq OWNED BY public.valoraciones.id_valoracion;
          public          postgres    false    226                       2604    165855    clientes idcliente    DEFAULT     x   ALTER TABLE ONLY public.clientes ALTER COLUMN idcliente SET DEFAULT nextval('public.clientes_idcliente_seq'::regclass);
 A   ALTER TABLE public.clientes ALTER COLUMN idcliente DROP DEFAULT;
       public          postgres    false    203    202            ?           2604    165856    detallepedidos iddetallefactura    DEFAULT     ?   ALTER TABLE ONLY public.detallepedidos ALTER COLUMN iddetallefactura SET DEFAULT nextval('public.detallepedidos_iddetallefactura_seq'::regclass);
 N   ALTER TABLE public.detallepedidos ALTER COLUMN iddetallefactura DROP DEFAULT;
       public          postgres    false    205    204            ?           2604    165857    direcciones iddireccion    DEFAULT     ?   ALTER TABLE ONLY public.direcciones ALTER COLUMN iddireccion SET DEFAULT nextval('public.direcciones_iddireccion_seq'::regclass);
 F   ALTER TABLE public.direcciones ALTER COLUMN iddireccion DROP DEFAULT;
       public          postgres    false    207    206            ?           2604    165858    facturas idfactura    DEFAULT     v   ALTER TABLE ONLY public.facturas ALTER COLUMN idfactura SET DEFAULT nextval('public.pedidos_idpedido_seq'::regclass);
 A   ALTER TABLE public.facturas ALTER COLUMN idfactura DROP DEFAULT;
       public          postgres    false    218    212            ?           2604    165859    historialcliente idregistro    DEFAULT     ?   ALTER TABLE ONLY public.historialcliente ALTER COLUMN idregistro SET DEFAULT nextval('public.historialcliente_idregistro_seq'::regclass);
 J   ALTER TABLE public.historialcliente ALTER COLUMN idregistro DROP DEFAULT;
       public          postgres    false    214    213            ?           2604    165860    historialusuario idregistro    DEFAULT     ?   ALTER TABLE ONLY public.historialusuario ALTER COLUMN idregistro SET DEFAULT nextval('public.historialusuario_idregistro_seq'::regclass);
 J   ALTER TABLE public.historialusuario ALTER COLUMN idregistro DROP DEFAULT;
       public          postgres    false    216    215            ?           2604    165861    productos idproducto    DEFAULT     |   ALTER TABLE ONLY public.productos ALTER COLUMN idproducto SET DEFAULT nextval('public.productos_idproducto_seq'::regclass);
 C   ALTER TABLE public.productos ALTER COLUMN idproducto DROP DEFAULT;
       public          postgres    false    220    219            ?           2604    165862    usuarios idusuario    DEFAULT     x   ALTER TABLE ONLY public.usuarios ALTER COLUMN idusuario SET DEFAULT nextval('public.usuarios_idusuario_seq'::regclass);
 A   ALTER TABLE public.usuarios ALTER COLUMN idusuario DROP DEFAULT;
       public          postgres    false    224    223            ?           2604    165863    valoraciones id_valoracion    DEFAULT     ?   ALTER TABLE ONLY public.valoraciones ALTER COLUMN id_valoracion SET DEFAULT nextval('public.valoraciones_id_valoracion_seq'::regclass);
 I   ALTER TABLE public.valoraciones ALTER COLUMN id_valoracion DROP DEFAULT;
       public          postgres    false    226    225            Z          0    165771 
   categorias 
   TABLE DATA           E   COPY public.categorias (idcategoria, seccion, categoria) FROM stdin;
    public          postgres    false    201   A?       [          0    165775    clientes 
   TABLE DATA           ?   COPY public.clientes (idcliente, estado, nombres, apellidos, dui, correo_electronico, clave, fecharegistro, codigo_recu, fechaclave, intentos) FROM stdin;
    public          postgres    false    202   ?       ]          0    165783    detallepedidos 
   TABLE DATA           f   COPY public.detallepedidos (iddetallefactura, pedido, producto, preciounitario, cantidad) FROM stdin;
    public          postgres    false    204   ?       _          0    165790    direcciones 
   TABLE DATA           d   COPY public.direcciones (iddireccion, cliente, direccion, codigo_postal, telefono_fijo) FROM stdin;
    public          postgres    false    206   H?       a          0    165795    estadocliente 
   TABLE DATA           9   COPY public.estadocliente (idestado, estado) FROM stdin;
    public          postgres    false    208   ??       b          0    165798    estadofactura 
   TABLE DATA           @   COPY public.estadofactura (idestado, estadofactura) FROM stdin;
    public          postgres    false    209   ??       c          0    165801    estadoproductos 
   TABLE DATA           ;   COPY public.estadoproductos (idestado, estado) FROM stdin;
    public          postgres    false    210   ?       d          0    165804    estadousuarios 
   TABLE DATA           :   COPY public.estadousuarios (idestado, estado) FROM stdin;
    public          postgres    false    211   6?       e          0    165807    facturas 
   TABLE DATA           Q   COPY public.facturas (idfactura, cliente, vendedor, estado, entrega) FROM stdin;
    public          postgres    false    212   o?       f          0    165810    historialcliente 
   TABLE DATA           N   COPY public.historialcliente (idregistro, cliente, sistema, hora) FROM stdin;
    public          postgres    false    213   ??       h          0    165816    historialusuario 
   TABLE DATA           N   COPY public.historialusuario (idregistro, usuario, sistema, hora) FROM stdin;
    public          postgres    false    215   |?       j          0    165822    marcas 
   TABLE DATA           0   COPY public.marcas (idmarca, marca) FROM stdin;
    public          postgres    false    217   ?       l          0    165827 	   productos 
   TABLE DATA           z   COPY public.productos (idproducto, categoria, estado, marca, producto, precio, descripcion, imagen, cantidad) FROM stdin;
    public          postgres    false    219   ܵ       n          0    165835 	   secciones 
   TABLE DATA           7   COPY public.secciones (idseccion, seccion) FROM stdin;
    public          postgres    false    221   ??       o          0    165838    tipousuarios 
   TABLE DATA           ;   COPY public.tipousuarios (idtipo, tipousuario) FROM stdin;
    public          postgres    false    222   ٸ       p          0    165841    usuarios 
   TABLE DATA           ?   COPY public.usuarios (idusuario, tipo, estado, usuario, clave, correo_electronico, fecharegistro, fechaclave, intentos, codigo_recu) FROM stdin;
    public          postgres    false    223   ?       r          0    165849    valoraciones 
   TABLE DATA           ?   COPY public.valoraciones (id_valoracion, id_detalle, calificacion_producto, comentario_producto, fecha_comentario, estado_comentario) FROM stdin;
    public          postgres    false    225   ??       ?           0    0    clientes_idcliente_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.clientes_idcliente_seq', 51, true);
          public          postgres    false    203            ?           0    0 #   detallepedidos_iddetallefactura_seq    SEQUENCE SET     R   SELECT pg_catalog.setval('public.detallepedidos_iddetallefactura_seq', 53, true);
          public          postgres    false    205            ?           0    0    direcciones_iddireccion_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.direcciones_iddireccion_seq', 19, true);
          public          postgres    false    207            ?           0    0 	   foo_a_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('public.foo_a_seq', 15, true);
          public          postgres    false    200            ?           0    0    historialcliente_idregistro_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.historialcliente_idregistro_seq', 31, true);
          public          postgres    false    214            ?           0    0    historialusuario_idregistro_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.historialusuario_idregistro_seq', 49, true);
          public          postgres    false    216            ?           0    0    pedidos_idpedido_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.pedidos_idpedido_seq', 44, true);
          public          postgres    false    218            ?           0    0    productos_idproducto_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.productos_idproducto_seq', 68, true);
          public          postgres    false    220            ?           0    0    usuarios_idusuario_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.usuarios_idusuario_seq', 12, true);
          public          postgres    false    224            ?           0    0    valoraciones_id_valoracion_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.valoraciones_id_valoracion_seq', 19, true);
          public          postgres    false    226            ?           2606    165865    categorias categorias_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (idcategoria);
 D   ALTER TABLE ONLY public.categorias DROP CONSTRAINT categorias_pkey;
       public            postgres    false    201            ?           2606    165867 (   clientes clientes_correo_electronico_key 
   CONSTRAINT     q   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_correo_electronico_key UNIQUE (correo_electronico);
 R   ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_correo_electronico_key;
       public            postgres    false    202            ?           2606    165869    clientes clientes_dui_key 
   CONSTRAINT     S   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_dui_key UNIQUE (dui);
 C   ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_dui_key;
       public            postgres    false    202            ?           2606    165871    clientes clientes_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (idcliente);
 @   ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_pkey;
       public            postgres    false    202            ?           2606    165873 "   detallepedidos detallepedidos_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.detallepedidos
    ADD CONSTRAINT detallepedidos_pkey PRIMARY KEY (iddetallefactura);
 L   ALTER TABLE ONLY public.detallepedidos DROP CONSTRAINT detallepedidos_pkey;
       public            postgres    false    204            ?           2606    165875    direcciones direcciones_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.direcciones
    ADD CONSTRAINT direcciones_pkey PRIMARY KEY (iddireccion);
 F   ALTER TABLE ONLY public.direcciones DROP CONSTRAINT direcciones_pkey;
       public            postgres    false    206            ?           2606    165877     estadocliente estadocliente_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.estadocliente
    ADD CONSTRAINT estadocliente_pkey PRIMARY KEY (idestado);
 J   ALTER TABLE ONLY public.estadocliente DROP CONSTRAINT estadocliente_pkey;
       public            postgres    false    208            ?           2606    165879    estadofactura estadopedido_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.estadofactura
    ADD CONSTRAINT estadopedido_pkey PRIMARY KEY (idestado);
 I   ALTER TABLE ONLY public.estadofactura DROP CONSTRAINT estadopedido_pkey;
       public            postgres    false    209            ?           2606    165881 *   estadoproductos estadoproductos_estado_key 
   CONSTRAINT     g   ALTER TABLE ONLY public.estadoproductos
    ADD CONSTRAINT estadoproductos_estado_key UNIQUE (estado);
 T   ALTER TABLE ONLY public.estadoproductos DROP CONSTRAINT estadoproductos_estado_key;
       public            postgres    false    210            ?           2606    165883 $   estadoproductos estadoproductos_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.estadoproductos
    ADD CONSTRAINT estadoproductos_pkey PRIMARY KEY (idestado);
 N   ALTER TABLE ONLY public.estadoproductos DROP CONSTRAINT estadoproductos_pkey;
       public            postgres    false    210            ?           2606    165885 (   estadousuarios estadousuarios_estado_key 
   CONSTRAINT     e   ALTER TABLE ONLY public.estadousuarios
    ADD CONSTRAINT estadousuarios_estado_key UNIQUE (estado);
 R   ALTER TABLE ONLY public.estadousuarios DROP CONSTRAINT estadousuarios_estado_key;
       public            postgres    false    211            ?           2606    165887 "   estadousuarios estadousuarios_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.estadousuarios
    ADD CONSTRAINT estadousuarios_pkey PRIMARY KEY (idestado);
 L   ALTER TABLE ONLY public.estadousuarios DROP CONSTRAINT estadousuarios_pkey;
       public            postgres    false    211            ?           2606    165889 &   historialcliente historialcliente_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.historialcliente
    ADD CONSTRAINT historialcliente_pkey PRIMARY KEY (idregistro);
 P   ALTER TABLE ONLY public.historialcliente DROP CONSTRAINT historialcliente_pkey;
       public            postgres    false    213            ?           2606    165891 &   historialusuario historialusuario_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.historialusuario
    ADD CONSTRAINT historialusuario_pkey PRIMARY KEY (idregistro);
 P   ALTER TABLE ONLY public.historialusuario DROP CONSTRAINT historialusuario_pkey;
       public            postgres    false    215            ?           2606    165893    marcas marcas_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.marcas
    ADD CONSTRAINT marcas_pkey PRIMARY KEY (idmarca);
 <   ALTER TABLE ONLY public.marcas DROP CONSTRAINT marcas_pkey;
       public            postgres    false    217            ?           2606    165895    facturas pedidos_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT pedidos_pkey PRIMARY KEY (idfactura);
 ?   ALTER TABLE ONLY public.facturas DROP CONSTRAINT pedidos_pkey;
       public            postgres    false    212            ?           2606    165897    productos productos_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (idproducto);
 B   ALTER TABLE ONLY public.productos DROP CONSTRAINT productos_pkey;
       public            postgres    false    219            ?           2606    165899     productos productos_producto_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_producto_key UNIQUE (producto);
 J   ALTER TABLE ONLY public.productos DROP CONSTRAINT productos_producto_key;
       public            postgres    false    219            ?           2606    165901    secciones secciones_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.secciones
    ADD CONSTRAINT secciones_pkey PRIMARY KEY (idseccion);
 B   ALTER TABLE ONLY public.secciones DROP CONSTRAINT secciones_pkey;
       public            postgres    false    221            ?           2606    165903    tipousuarios tipousuarios_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.tipousuarios
    ADD CONSTRAINT tipousuarios_pkey PRIMARY KEY (idtipo);
 H   ALTER TABLE ONLY public.tipousuarios DROP CONSTRAINT tipousuarios_pkey;
       public            postgres    false    222            ?           2606    165905 )   tipousuarios tipousuarios_tipousuario_key 
   CONSTRAINT     k   ALTER TABLE ONLY public.tipousuarios
    ADD CONSTRAINT tipousuarios_tipousuario_key UNIQUE (tipousuario);
 S   ALTER TABLE ONLY public.tipousuarios DROP CONSTRAINT tipousuarios_tipousuario_key;
       public            postgres    false    222            ?           2606    165907    valoraciones unico 
   CONSTRAINT     S   ALTER TABLE ONLY public.valoraciones
    ADD CONSTRAINT unico UNIQUE (id_detalle);
 <   ALTER TABLE ONLY public.valoraciones DROP CONSTRAINT unico;
       public            postgres    false    225            ?           2606    165909 (   usuarios usuarios_correo_electronico_key 
   CONSTRAINT     q   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_electronico_key UNIQUE (correo_electronico);
 R   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_correo_electronico_key;
       public            postgres    false    223            ?           2606    165911    usuarios usuarios_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (idusuario);
 @   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_pkey;
       public            postgres    false    223            ?           2606    165913    usuarios usuarios_usuario_key 
   CONSTRAINT     [   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_usuario_key UNIQUE (usuario);
 G   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_usuario_key;
       public            postgres    false    223            ?           2606    165915    valoraciones valoraciones_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.valoraciones
    ADD CONSTRAINT valoraciones_pkey PRIMARY KEY (id_valoracion);
 H   ALTER TABLE ONLY public.valoraciones DROP CONSTRAINT valoraciones_pkey;
       public            postgres    false    225            ?           2606    165916 "   categorias categorias_seccion_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_seccion_fkey FOREIGN KEY (seccion) REFERENCES public.secciones(idseccion);
 L   ALTER TABLE ONLY public.categorias DROP CONSTRAINT categorias_seccion_fkey;
       public          postgres    false    221    3000    201            ?           2606    165921    clientes clientes_estado_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_estado_fkey FOREIGN KEY (estado) REFERENCES public.estadocliente(idestado);
 G   ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_estado_fkey;
       public          postgres    false    208    202    2976            ?           2606    165926 )   detallepedidos detallepedidos_pedido_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.detallepedidos
    ADD CONSTRAINT detallepedidos_pedido_fkey FOREIGN KEY (pedido) REFERENCES public.facturas(idfactura);
 S   ALTER TABLE ONLY public.detallepedidos DROP CONSTRAINT detallepedidos_pedido_fkey;
       public          postgres    false    204    212    2988            ?           2606    165931 +   detallepedidos detallepedidos_producto_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.detallepedidos
    ADD CONSTRAINT detallepedidos_producto_fkey FOREIGN KEY (producto) REFERENCES public.productos(idproducto);
 U   ALTER TABLE ONLY public.detallepedidos DROP CONSTRAINT detallepedidos_producto_fkey;
       public          postgres    false    204    219    2996            ?           2606    165936 $   direcciones direcciones_cliente_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.direcciones
    ADD CONSTRAINT direcciones_cliente_fkey FOREIGN KEY (cliente) REFERENCES public.clientes(idcliente);
 N   ALTER TABLE ONLY public.direcciones DROP CONSTRAINT direcciones_cliente_fkey;
       public          postgres    false    202    2970    206            ?           2606    165941 .   historialcliente historialcliente_cliente_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.historialcliente
    ADD CONSTRAINT historialcliente_cliente_fkey FOREIGN KEY (cliente) REFERENCES public.clientes(idcliente);
 X   ALTER TABLE ONLY public.historialcliente DROP CONSTRAINT historialcliente_cliente_fkey;
       public          postgres    false    213    2970    202            ?           2606    165946 .   historialusuario historialusuario_usuario_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.historialusuario
    ADD CONSTRAINT historialusuario_usuario_fkey FOREIGN KEY (usuario) REFERENCES public.usuarios(idusuario);
 X   ALTER TABLE ONLY public.historialusuario DROP CONSTRAINT historialusuario_usuario_fkey;
       public          postgres    false    3008    223    215            ?           2606    165951    facturas pedidos_cliente_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT pedidos_cliente_fkey FOREIGN KEY (cliente) REFERENCES public.clientes(idcliente);
 G   ALTER TABLE ONLY public.facturas DROP CONSTRAINT pedidos_cliente_fkey;
       public          postgres    false    212    202    2970            ?           2606    165956    facturas pedidos_entrega_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT pedidos_entrega_fkey FOREIGN KEY (entrega) REFERENCES public.direcciones(iddireccion);
 G   ALTER TABLE ONLY public.facturas DROP CONSTRAINT pedidos_entrega_fkey;
       public          postgres    false    2974    212    206            ?           2606    165961    facturas pedidos_estado_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT pedidos_estado_fkey FOREIGN KEY (estado) REFERENCES public.estadofactura(idestado);
 F   ALTER TABLE ONLY public.facturas DROP CONSTRAINT pedidos_estado_fkey;
       public          postgres    false    209    2978    212            ?           2606    165966    facturas pedidos_vendedor_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT pedidos_vendedor_fkey FOREIGN KEY (vendedor) REFERENCES public.usuarios(idusuario);
 H   ALTER TABLE ONLY public.facturas DROP CONSTRAINT pedidos_vendedor_fkey;
       public          postgres    false    3008    223    212            ?           2606    165971    productos productos_estado_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_estado_fkey FOREIGN KEY (estado) REFERENCES public.estadoproductos(idestado);
 I   ALTER TABLE ONLY public.productos DROP CONSTRAINT productos_estado_fkey;
       public          postgres    false    2982    210    219            ?           2606    165976    productos productos_marca_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_marca_fkey FOREIGN KEY (marca) REFERENCES public.marcas(idmarca);
 H   ALTER TABLE ONLY public.productos DROP CONSTRAINT productos_marca_fkey;
       public          postgres    false    219    217    2994            ?           2606    165981    usuarios usuarios_estado_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_estado_fkey FOREIGN KEY (estado) REFERENCES public.estadousuarios(idestado);
 G   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_estado_fkey;
       public          postgres    false    223    2986    211            ?           2606    165986    usuarios usuarios_tipo_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_tipo_fkey FOREIGN KEY (tipo) REFERENCES public.tipousuarios(idtipo);
 E   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_tipo_fkey;
       public          postgres    false    223    3002    222            ?           2606    165991 )   valoraciones valoraciones_id_detalle_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.valoraciones
    ADD CONSTRAINT valoraciones_id_detalle_fkey FOREIGN KEY (id_detalle) REFERENCES public.detallepedidos(iddetallefactura);
 S   ALTER TABLE ONLY public.valoraciones DROP CONSTRAINT valoraciones_id_detalle_fkey;
       public          postgres    false    225    2972    204            Z   ?   x?%???0Eם????K?\?ŝ??^?????Aww?͜?TiUsxc??$???S&4??[??:?????
·??+;??|??¼6x?@[a˭????JU?'I{I5Z?Ɠ^?P?M?HZ?L?oҩ???????L:?ۧwM???Hk??W?w?o?I????C??0=D?????      [     x?e??R?0??u??.?B???V"?j????? E
)?R-?'???gQ?q}ޙ?P? ?ʼh?L???6?"??M)!GO??N????Bɲ6?F!??:`???i???h???(N????!????n??˃???$?ͯ?[??D0?0?3 ?e?j??ۈ?0?
?kN@?i?u?-???l+_????ܺ??r???:e??␮??W?9?Lxk{?Wq4????s?Q2????? ?K,?b&a,?g??|?MM?>??X?      ]      x?35?41?46?427?30?4?????? +?i      _   6   x?3??45?t?,JMN???SH?IM,?/?L?4440?4????55???????? 1??      a      x?3?tL.?,??2???K?0c???? ^??      b   8   x?3?H?K?L?+IUHN?KN?IL????2?t??K?ɬJL??2?t?H?1z\\\ ?'      c   $   x?3?t?,.???L?I?2?tL?/IL??????? ~??      d   )   x?3?tL.?,??2?t??/,MML??2???K???qqq ?
?      e      x?31?45?44?4????????? N?      f   ?  x????nAF?????;??؞."T@??*?&?!^?ͥ?D?H[??????v??y??????????????????????w??p????㷇???Wo&|?]|??z`d:bֵQ,??sLG1n?.?aɆҏ?e8?s*?????0?T???BlD????-? e2x???P??????R?J?l?.?????|Y?#?????5?3????b?Vр???
?B?
?i.?FŞ?l??J?Nu??L{|PI:?=?y?N^???Q3_*?U?????i??z??'D?j????????6???̗?6L<lw?{??2l?????^??}?p}s?r{?2>???V?s?#????'~???/?~?\?ё??????OopP?gv??8??V???j?V=?????l 9c?'????՟"S??e|??k?G??ʳ?{??؜ ?????]?^????J?ʧ?|0?? ??o?Լ      h   ?  x????n1???)??"??zlw?B?Oh?P?H
?x}???vh?]]}ww?ߙ?]?\}z????׏????????????/?!B6?Jۗ?O_7d?=??c???͛?fWB??4??m?S???$M?O?;On??Gi?x??5?x??x?:ja??'?Qx??u????N??5H-ZaJ?Zk5?ŭ0??e?UU??t?Mj?w?QX??m?_5???|~??)+????x?ꍂ??lu?t?"??a?ls?]t'?luc2????S8[^??$??8l?-oL?i^? ?H???q_c?F5?V$Uޝ??Gu?!|$U??p@?I??"???????o?>?I???W?g#(P$???V?a?G?T/|? ?~q/??????i5?f8????|?ITG?i?T}/??xFo?E??EmV??b?????o_?C?`4???S??K_E??.=?h??c???⭋???2m????Հ????????,?颙????ֆͰEѣ??/߿Zp??????????^??;???G{?????V?N?#}???y>>a?O?k??Q??|Lw?u?a?Ŏ?&?ejTL?Q??|?k?8..<??=???E;?F????=?ǭ?sx??Ŏ????ۃz????????v\???i?)p?S???q???@<X??;?A<???\??ZJ??1?      j   ?   x?EN?
?@?w??/?l?QK? ?Z?"6k???1?????{ja7/f&?m?EF??y?:<mc9Χ
3?X#?WP̩?????r???i_n?)?zc??7pF?ZxBE?cdJePmk??????mDqD;;x??*uiGg}?/??}? wE???`$V?r?F쓇:?4?R?h<rx?e>:      l   ?  x?m??n?0???)?+c??????JR??^ۻ?05?J?VQ!/ֱ?(???????x$'e??>??c?DJ?c?|^?	??XZr:̺?~"?5?}?7Z 7??x"?R?9????`C?!z?#e?q??6??K??G?????@?<?[-?uY[???%I?3??????-?.!??1?&??????`??ͬ?{?;P?s???(?ی??B&[??d#=A?????b6????????wي????<Ť????EjEKA?+rwwEo?NN??M?S?1??w???dSf??e??,?I?gSf?0Y?;<??H???i???鱛?>?\x?F????)????̸[??1ARyj?2S({??????G??P???=*? 0???a8???*I???[?|???Yvf??lO?s????"?B??M?u84?贳?v??A%?8?vET??4g????Y?Ctѵ?f7?U???`\??o60???-(?=-?Ʒ?U?^p0???>8???.?`?F"g,?_}К?6*
-2??;????`??\&?͇=?<?|y:W{??H<Ѹ???{S????#??v???????Њ1fF???V???$?*dE?{x}????f??w??????????`k?*a???,D?n?TT??tx????????σ?^?O#?\??????(?km]u      n   0   x?3??H,J)O,J?2?H-?L???b.cN???????L 'F??? -?,      o   ,   x?3???/?2?tL????,.)JL?/?2?K?KI1c???? ???      p   ?   x?=??
?@ ????h?V????c*!Ee??Ƣ??PYY_?"h}?AR???i??mZe?g[.hw????g?6??8]S^?????:?j(?e?y?0?H??6?ʕ??궬?lZ`d?1?Q?ȋ؋&?x ???O??8:B?/??)?      r      x?????? ? ?     