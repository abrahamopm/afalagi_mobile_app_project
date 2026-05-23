import mongoose, { Document, Schema } from 'mongoose';

export interface IViewing extends Document {
  user: mongoose.Types.ObjectId;
  property: mongoose.Types.ObjectId;
  client: mongoose.Types.ObjectId;
  date: string;
  status: string;
  notes?: string;
  interestScore: number;
  createdAt: Date;
}

const ViewingSchema: Schema = new Schema({
  user: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  property: {
    type: Schema.Types.ObjectId,
    ref: 'Property',
    required: [true, 'Please associate a property'],
  },
  client: {
    type: Schema.Types.ObjectId,
    ref: 'Client',
    required: [true, 'Please associate a client'],
  },
  date: {
    type: String,
    required: [true, 'Please add a viewing date/time'],
  },
  status: {
    type: String,
    default: 'Recent',
  },
  notes: {
    type: String,
    default: '',
  },
  interestScore: {
    type: Number,
    min: 0,
    max: 5,
    default: 0,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

export default mongoose.model<IViewing>('Viewing', ViewingSchema);
