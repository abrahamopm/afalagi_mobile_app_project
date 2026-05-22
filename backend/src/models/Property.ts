import mongoose, { Document, Schema } from 'mongoose';

export interface IProperty extends Document {
  user: mongoose.Types.ObjectId;
  title: string;
  description: string;
  location: string;
  imageUrl: string;
  price: number;
  beds: number;
  baths: number;
  sqft: number;
  isAvailable: boolean;
  tags: string[];
  createdAt: Date;
}

const PropertySchema: Schema = new Schema({
  user: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  title: {
    type: String,
    required: [true, 'Please add a property title'],
    trim: true,
  },
  description: {
    type: String,
    default: '',
  },
  location: {
    type: String,
    required: [true, 'Please add a location'],
  },
  imageUrl: {
    type: String,
    default: 'assets/images/generic_property.png',
  },
  price: {
    type: Number,
    required: [true, 'Please add a price'],
  },
  beds: {
    type: Number,
    required: [true, 'Please add number of bedrooms'],
  },
  baths: {
    type: Number,
    required: [true, 'Please add number of bathrooms'],
  },
  sqft: {
    type: Number,
    required: [true, 'Please add sqft area'],
  },
  isAvailable: {
    type: Boolean,
    default: true,
  },
  tags: {
    type: [String],
    default: [],
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

export default mongoose.model<IProperty>('Property', PropertySchema);
