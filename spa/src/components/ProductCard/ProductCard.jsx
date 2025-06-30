import './ProductCard.css'

function ProductCard({ product }) {
  return (
    <div className="product-card">
      <img 
        src={product.thumbnail} 
        alt={product.title}
        loading="lazy"
      />
      <h3>{product.title}</h3>
      <p className="price">${product.price}</p>
      <p className="category">{product.category}</p>
    </div>
  )
}

export default ProductCard 